//
//  BabyViewModel.swift
//  Babylo
//
//  Created by Babylo  on 11/4/2023.
//

import Foundation
import Combine
import UIKit
import Alamofire

class BabyViewModel: ObservableObject {
    @Published var babies = [Baby]()
    @Published var heights : [Height] = []
    @Published var weights : [Weight] = []
    @Published var vaccines: [Vaccine] = []
    @Published var appointments: [Doctor] = []
    private var cancellables : Set<AnyCancellable> = []
    @Published var upcomingVaccines: [UpcomingVaccine] = []
    @Published var baby: Baby?
    
    let token: String
    let baseUrl = "http://localhost:8080/user/baby"
    
    
    init(token: String = UserDefaults.standard.string(forKey: "token") ?? "")
    {
        self.token = token
        setupPublisher()
    }
    
    
    private func setupPublisher() {
            $heights
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
    
    func fetchBabies() {
        let url = URL(string: "\(baseUrl)/getbabylist")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Baby].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching babies: \(error)")
                }
            } receiveValue: { babies in
                self.babies = babies
            }
            .store(in: &cancellables)

    }
    
    func addBaby(token: String, babyName: String, birthday: Date, gender: String, babyPic: UIImage, completion: @escaping (Result<Bool, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedBirthday = dateFormatter.string(from: birthday)
        
        let parameters: [String: Any] = [
        "babyName": babyName,
        "birthday": formattedBirthday,
        "gender": gender
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
                    for (key, value) in parameters {
                        if let stringValue = value as? String {
                            if let data = stringValue.data(using: .utf8) {
                                multipartFormData.append(data, withName: key)
                            }
                        }
                    }
                    
                    if let imageData = babyPic.jpegData(compressionQuality: 0.5) {
                        multipartFormData.append(imageData, withName: "babyPic", fileName: "baby.jpg", mimeType: "image/jpeg")
                    }
                }, to: "http://localhost:8080/user/baby/addBaby", headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        
        
    }
    
    func deleteBaby(token:String,babyName:String,completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "\(baseUrl)/deleteBaby")!
            let parameters: [String: Any] = [
                "token": token,
                "babyName": babyName
            ]

        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

    }
        
    func getBaby(token:String,babyName:String, completion: @escaping (Result<Baby, Error>) -> Void){
        let url = URL(string: "\(baseUrl)/getBaby")!
                let authHeader = ["Authorization": "Bearer \(token)"]
                let body = ["babyName": babyName]
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = authHeader
                request.httpBody = try? JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                        return
                    }
                    
                    if let data = data {
                        do {
                            let babyResponse = try JSONDecoder().decode(Baby.self, from: data)
                            DispatchQueue.main.async {
                                completion(.success(babyResponse))
                            }
                        } catch {
                            DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                        }
                    }
                }.resume()
            }
    
    
    func addHeight(token: String, height: String, babyName: String, completion: @escaping (Result<Height, Error>) -> Void) {
        let url = "\(baseUrl)/addHeight"
        let headers: HTTPHeaders = [        "Authorization": "Bearer \(token)",        "Content-Type": "application/json"    ]
        let parameters: [String: Any] = [        "height": height,        "babyName": babyName    ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: Height.self) { response in
            switch response.result {
            case .success(let height):
                completion(.success(height))
                print("Height added successfully.")
            case .failure(let error):
                completion(.failure(error))
                print("Error adding height: \(error)")
            }
        }
    }


    func getBabyHeights(token: String, babyName: String, completion: @escaping (Result<[Height], Error>) -> Void) {
        let url = "http://localhost:8080/user/baby/getBabyHeights"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "babyName": babyName
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: [Height].self) { response in
            switch response.result {
            case .success(let heights):
                DispatchQueue.main.async {
                    self.heights = heights
                }
                completion(.success(heights))
                print("Baby heights loaded successfully.")
            case .failure(let error):
                completion(.failure(error))
                print("Error loading baby heights: \(error)")
            }
        }
    }

    
    func deleteHeight(token: String, date: String, babyName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseUrl)/deleteHeight"
        let headers: HTTPHeaders = [
                   "Content-Type": "application/json"
               ]
               
               let parameters: [String: Any] = [
                   "token": token,
                   "date": date,
                   "babyName": babyName
               ]
               
               AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                   switch response.result {
                   case .success:
                       completion(.success("Height deleted"))
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
        }
    
    
    func addWeight(token: String, weight: String, babyName: String, completion: @escaping (Result<Weight, Error>) -> Void) {
        let url = "\(baseUrl)/addWeight"
        let headers: HTTPHeaders = [        "Authorization": "Bearer \(token)",        "Content-Type": "application/json"    ]
        let parameters: [String: Any] = [        "weight": weight,        "babyName": babyName    ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: Weight.self) { response in
            switch response.result {
            case .success(let weight):
                completion(.success(weight))
                print("weight added successfully.")
            case .failure(let error):
                completion(.failure(error))
                print("Error adding height: \(error)")
            }
        }
    }
    
    func getBabyWeights(token: String, babyName: String, completion: @escaping (Result<[Weight], Error>) -> Void) {
        let url = "\(baseUrl)/getBabyWeights"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "babyName": babyName
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: [Weight].self) { response in
            switch response.result {
            case .success(let weights):
                DispatchQueue.main.async {
                    self.weights = weights
                }
                completion(.success(weights))
                print("Baby weights loaded successfully.")
            case .failure(let error):
                completion(.failure(error))
                print("Error loading baby weights: \(error)")
            }
        }
    }
    
    
    func deleteWeight(token: String, date: String, babyName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseUrl)/deleteWeight"
        let headers: HTTPHeaders = [
                   "Content-Type": "application/json"
               ]
               
               let parameters: [String: Any] = [
                   "token": token,
                   "date": date,
                   "babyName": babyName
               ]
               
               AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                   switch response.result {
                   case .success:
                       completion(.success("Weight deleted"))
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
        }
    
    func addVaccine(token: String, vaccine: String, date: String, babyName: String, completion: @escaping (Result<Vaccine, Error>) -> Void){
        
        let url = "\(baseUrl)/addVaccine"
        let headers: HTTPHeaders = [        "Authorization": "Bearer \(token)",        "Content-Type": "application/json"    ]
        let parameters: [String: Any] = [        "vaccine": vaccine,        "babyName": babyName, "date": date,    ]
        
        AF.request(url,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: Vaccine.self) { response in
            
            switch response.result {
            case .success(let newVaccine) :
                DispatchQueue.main.async {
                    self.vaccines.append(newVaccine)
                }
            case .failure(let error) :
                print("Error adding vaccine: \(error)")
            }
        }
        
    }
    
    func deleteVaccine(token: String, date: String, babyName: String, vaccine: String, completion: @escaping (Result<String, Error>) -> Void){
        let url = "\(baseUrl)/deleteVaccine"
        let headers: HTTPHeaders = [
                   "Content-Type": "application/json"
               ]
               
               let parameters: [String: Any] = [
                   "token": token,
                   "date": date,
                   "babyName": babyName,
                   "vaccine": vaccine
               ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                completion(.success("Vaccine deleted"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func getVaccines (token: String, babyName: String, completion: @escaping (Result<[Vaccine], Error>) -> Void){
        
        let url = "\(baseUrl)/getbabyvaccines"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "babyName": babyName
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: [Vaccine].self) { response in
            switch response.result {
            case .success(let vaccines):
                DispatchQueue.main.async {
                    self.vaccines = vaccines
                }
                completion(.success(vaccines))
                print("Baby vaccines loaded successfully.")
            case .failure(let error):
                completion(.failure(error))
                print("Error loading baby vaccines: \(error)")
            }
        }
    }
    
    func addAppointment(token: String, doctor: String, date: String, babyName: String, time: String, completion: @escaping (Result<Doctor, Error>) -> Void){
        
        let url = "\(baseUrl)/addConsultation"
        let headers: HTTPHeaders = [        "Authorization": "Bearer \(token)",        "Content-Type": "application/json"    ]
        let parameters: [String: Any] = [        "doctor": doctor,        "babyName": babyName, "date": date,  "time": time  ]
        
        AF.request(url,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: Doctor.self) { response in
            
            switch response.result {
            case .success(let newAppointment) :
                DispatchQueue.main.async {
                    self.appointments.append(newAppointment)
                }
            case .failure(let error) :
                print("Error adding vaccine: \(error)")
            }
        }
        
    }
    
    func deleteAppointment(token: String, date: String, babyName: String, time: String, completion: @escaping (Result<String, Error>) -> Void){
        
        let url = "\(baseUrl)/deleteConsultation"
        let headers: HTTPHeaders = [
                   "Content-Type": "application/json"
               ]
               
               let parameters: [String: Any] = [
                   "token": token,
                   "date": date,
                   "babyName": babyName,
                   "time" : time
               ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                completion(.success("Appointment deleted"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAppointments(token: String, babyName: String, completion: @escaping (Result<[Doctor], Error>) -> Void){
        
        let url = "\(baseUrl)/getDoctorConsultations"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "babyName": babyName
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: [Doctor].self) { response in
            switch response.result {
            case .success(let appointments):
                DispatchQueue.main.async {
                    self.appointments = appointments
                }
                completion(.success(appointments))
                print("Doctor appointments loaded successfully.")
            case .failure(let error):
                completion(.failure(error))
                print("Error loading doctor appointments: \(error)")
            }
        }
        
    }
    
    func getUpcomingVaccines(token:String, completion: @escaping (Result<[UpcomingVaccine], Error>) -> Void) {
        let url = "\(baseUrl)/getUpcomingVaccines"
        let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(token)"
                ]
        AF.request(url, method: .post,headers: headers).validate().responseDecodable(of: [UpcomingVaccine].self) { (response: DataResponse<[UpcomingVaccine], AFError>) in
                switch response.result {
                case .success(let vaccines):
                    DispatchQueue.main.async {
                        self.upcomingVaccines = vaccines
                    }
                    completion(.success(vaccines))
                case .failure(let error):
                    completion(.failure(error))
                    print("Error loading upcoming vaccines: \(error)")
                }
            }

        
    }
    
    
    func fetchUpcomingConsultations(babyName: String, completion: @escaping (Result<[Doctor], Error>) -> Void){
        let url = "\(baseUrl)/getUpcomingConsultations"
        let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(token)"
                ]
                
                let parameters: Parameters = [
                    "babyName": babyName
                ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: [Doctor].self) { response in
            switch response.result {
            case .success(let appointments):
                completion(.success(appointments))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

    func updateBaby(token: String, babyName: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseUrl)/updateBaby"
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)"
            ]

          
            AF.upload(multipartFormData: { multipartFormData in
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    multipartFormData.append(imageData, withName: "babyPic", fileName: "babyPic.jpg", mimeType: "image/jpeg")
                }
                multipartFormData.append(Data(babyName.utf8), withName: "babyName")
            }, to: url, method: .put, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    completion(.success("Baby photo updated"))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

    




}


