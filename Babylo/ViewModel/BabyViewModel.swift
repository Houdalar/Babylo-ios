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
    private let token: String
    
    
    init(token: String) {
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
    
}
