//
//  NetworkManager.swift
//  Test2
//
//  Created by Рамил Гаджиев on 07.10.2021.
//

import Foundation


class NetworkManager {
    
    let urlString = "http://94.127.67.113:8099/"
    
    static let shared = NetworkManager()
    private init() {}
    
    func registerUser (userToRegistr: UserModel, completion: @escaping (UserModel?, Errors?) -> Void) {
        guard let url = URL(string: "\(urlString)registerUser") else {
            completion(nil, Errors.invalidURL)
            return
        }
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = try JSONEncoder().encode(userToRegistr)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let jsonData = data else {
                    completion(nil, Errors.serverProblem)
                    return
                }
                do {
                    let userData = try JSONDecoder().decode(UserModel.self, from: jsonData)
                    completion(userData, nil)
                    
                } catch {
                    completion(nil, Errors.decodeDataProblem)
                }
            }
            dataTask.resume()
        } catch {
            completion(nil, Errors.encodeDataProblem)
        }
    }
    
    func checkLogin (userToLogin: [String: String], completion: @escaping (UserModel?, Errors?) -> Void) {
        guard let url = URL(string: "\(urlString)checkLogin") else {
            completion(nil, Errors.invalidURL)
            return
        }
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = try JSONEncoder().encode(userToLogin)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let jsonData = data else {
                    completion(nil, Errors.serverProblem)
                    return
                }
                do {
                    let userData = try JSONDecoder().decode(UserModel.self, from: jsonData)
                    completion(userData, nil)
                } catch {
                    completion(nil, Errors.decodeDataProblem)
                }
            }
            dataTask.resume()
        } catch {
            completion(nil, Errors.encodeDataProblem)
        }
    }
    
    func updateProfile (userToUpdate: UserModel, completion: @escaping (UserModel?, Errors?) -> Void) {
        guard let url = URL(string: "\(urlString)updateProfile") else {
            completion(nil, Errors.invalidURL)
            return
        }
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = try JSONEncoder().encode(userToUpdate)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let jsonData = data else {
                    completion(nil, Errors.serverProblem)
                    return
                }
                do {
                    let userData = try JSONDecoder().decode(UserModel.self, from: jsonData)
                    completion(userData, nil)
                    
                } catch {
                    completion(nil, Errors.decodeDataProblem)
                }
            }
            dataTask.resume()
        } catch {
            completion(nil, Errors.encodeDataProblem)
        }
    }
}
