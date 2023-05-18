import Foundation
import Alamofire

class AudioBookViewModel: ObservableObject {
    @Published var audioBooksByCategory: [AudioBook] = []
    @Published var newestAudioBooks: [AudioBook] = []
    @Published var topAudioBooks: [AudioBook] = []
    @Published var topRatedAudioBooks: [AudioBook] = []
    @Published var booksByCategory: [String: [AudioBook]] = [:]
    @Published var bookShelf: [AudioBook] = []
    private let token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MTc1YjE3YmYwZmFmZmY1OGRlOTRjMiIsImlhdCI6MTY4NDMyNTg1M30.8G6Pn8zjOMiMv_iWfwmvcLMljBMU4nr0CN5ova9Xu_Y"

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

    
    func fetchBookShelf() {
            let parameters: [String: Any] = ["token": token]
            let url = "http://localhost:8080/user/audiobook/getFavoritesbooks" 

            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(of: [AudioBook].self) { (response) in
                    guard let books = response.value else { return }
                    DispatchQueue.main.async {
                        self.bookShelf = books
                        print(response.value)
                    }
                }
        }
    
    func addToBookShelf(bookId: String, completionHandler: @escaping (Error?) -> Void) {
        let parameters: [String: Any] =  ["token": token, "bookid": bookId]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(baseURL+"user/audiobook/addFavoritesbooks", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    func removeFromBookShelf(bookId: String, completionHandler: @escaping (Error?) -> Void) {
        let parameters: [String: Any] = ["token": token, "bookid": bookId]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(baseURL+"user/audiobook/removeFavoritesbooks", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                self.fetchBookShelf()
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    func updateBookRating(bookId: String, newRating: Double, completionHandler: @escaping (Error?) -> Void) {
        let parameters: [String: Any] = ["id": bookId, "Rating": newRating]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(baseURL+"media/updateRatingAudioBook", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                self.fetchBookShelf()
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
}

    
