//
//  BabyViewModel.swift
//  Babylo
//
//  Created by Babylo  on 11/4/2023.
//

import Foundation
import Combine

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
}

