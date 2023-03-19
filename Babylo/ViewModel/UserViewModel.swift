//
//  UserViewModel.swift
//  Babylo
//
//  Created by houda lariani on 16/3/2023.
//

import Foundation
import  Alamofire
import Combine
import CoreData
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAuthenticated = false
    @Published var isRegistred = false
    private let baseURL = "http://localhost:8080/"
    
    func login(email: String, password: String, onSuccess: @escaping (_ token: String) -> Void, onFailure: @escaping (_ title: String, _ message: String) -> Void) {
        AF.request(baseURL+"user/login" ,
                   method: .post,
                   parameters: [ "email" : email, "password" : password ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<403)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    guard let jsonData = data as? [String: Any],
                          let statusCode = response.response?.statusCode else {
                        onFailure("Error", "Invalid response format")
                        return
                    }

                    switch statusCode {
                    case 200:
                        guard let token = jsonData["token"] as? String else {
                            onFailure("Error", "Invalid response format")
                            return
                        }
                        // Store token in UserDefaults
                        UserDefaults.standard.set(token, forKey: "token")
                        
                        // Set isAuthenticated to true and navigate to home page
                        self.isAuthenticated = true
                        onSuccess(token)
                        
                    case 400:
                        onFailure("Login failed", "Invalid password")
                    case 402:
                        onFailure("Account not activated", "Your email address has not been verified")
                    default:
                        onFailure("User not found", "This email address is not associated with any account")
                    }
                case .failure(let error):
                    print(error)
                    onFailure("Error", "Network request failed")
                }
            }
    }

    
    func Signup(email: String, password: String, name: String, onSuccess: @escaping (_ title: String, _ message: String) -> Void, onFailure: @escaping (_ title: String, _ message: String) -> Void) {
        AF.request(baseURL+"user/signup" ,
                   method: .post,
                   parameters: [ "email" : email, "password" : password, "name" : name ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<401)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    guard let jsonData = data as? [String: Any],
                          let statusCode = response.response?.statusCode else {
                        onFailure("Error", "Invalid response format")
                        return
                    }

                    switch statusCode {
                    case 200:
                        self.isRegistred = true
                         onSuccess("Welcome", "Thanks for joining our comunity please check the email  sent to you to activate your account")
                    case 400:
                         onFailure("Register failed", "This email is already associated to an account . please use another one or reset your password")
                    default:
                         onFailure("Error", "something went wrong please try again")
                    }
                case .failure(let error):
                    print(error)
                    onFailure("Error", "Network request failed")
                }
            }
    }




    
    

}

