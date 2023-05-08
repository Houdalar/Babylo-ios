import Foundation
import Alamofire

class AudioBookViewModel: ObservableObject {
    @Published var audioBooksByCategory: [AudioBook] = []
    @Published var newestAudioBooks: [AudioBook] = []
    @Published var topAudioBooks: [AudioBook] = []
    @Published var topRatedAudioBooks: [AudioBook] = []
    @Published var booksByCategory: [String: [AudioBook]] = [:]

    private let baseURL = "http://localhost:8080/"

    func fetchAudioBooksByCategory(category: String) {
        let parameters: Parameters = ["category": category]

        AF.request(baseURL + "media/getAudioBookByCategory", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [AudioBook].self) { response in
                switch response.result {
                case .success(let audioBooks):
                    DispatchQueue.main.async {
                        self.booksByCategory[category] = audioBooks
                    }
                case .failure(let error):
                    print("Error decoding audio books by category: \(error)")
                }
            }
    }

    func fetchNewestAudioBooks() {
        AF.request(baseURL + "media/getNewestAudioBook", method: .get)
            .validate()
            .responseDecodable(of: [AudioBook].self) { response in
                switch response.result {
                case .success(let audioBooks):
                    DispatchQueue.main.async {
                        self.newestAudioBooks = audioBooks
                    }
                case .failure(let error):
                    print("Error decoding newest audio books: \(error)")
                }
            }
    }

    func fetchTopAudioBooks() {
        AF.request(baseURL + "media/getTopAudioBook", method: .get)
            .validate()
            .responseDecodable(of: [AudioBook].self) { response in
                switch response.result {
                case .success(let audioBooks):
                    DispatchQueue.main.async {
                        self.topAudioBooks = audioBooks
                    }
                case .failure(let error):
                    print("Error decoding top audio books: \(error)")
                }
            }
    }

    func fetchTopRatedAudioBooks() {
        AF.request(baseURL + "media/getTopRatedAudioBook", method: .get)
            .validate()
            .responseDecodable(of: [AudioBook].self) { response in
                switch response.result {
                case .success(let audioBooks):
                    DispatchQueue.main.async {
                        self.topRatedAudioBooks = audioBooks
                    }
                case .failure(let error):
                    print("Error decoding top rated audio books: \(error)")
                }
            }
    }

    func updateRatingAudioBook(id: String, rating: Double) {
        let parameters: Parameters = ["id": id, "Rating": rating]

        AF.request(baseURL + "media/updateRatingAudioBook", method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: AudioBook.self) { response in
                switch response.result {
                case .success(let audioBook):
                    print("Rating updated successfully for audio book: \(audioBook)")
                case .failure(let error):
                    print("Error updating rating for audio book: \(error)")
                }
            }
    }
}

    
