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
    private var cancellables = Set<AnyCancellable>()
    let token: String
    
    
    init(token: String = UserDefaults.standard.string(forKey: "token") ?? "")
    {
        self.token = token
    }
    
    func fetchBabies() {
        let url = URL(string: "http://localhost:8080/user/baby/getbabylist")!
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
        let url = URL(string: "http://localhost:8080/user/baby/deleteBaby")!
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
        let url = URL(string: "http://localhost:8080/user/baby/getBaby")!
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
    }
