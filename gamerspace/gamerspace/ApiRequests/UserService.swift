//
//  UserResponses.swift
//  gamerspace
//
//  Created by Michael Morales on 5/4/21.
//

import Foundation

struct UserService {
    
    func searchUsers(username: String, completionHander: @escaping ([User]) -> Void) {
        let url = URL(string: "http://104.236.83.241/api/users/search/\(username)")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for errors
            if let error = error {
                print(error)
                return
            }
            
            // Get HTTP Response
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode([User].self, from: data)
                    completionHander(response)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func getLoggedInUser(completionHander: @escaping (User) -> Void) {
        let url = URL(string: "http://104.236.83.241/api/users/getLoggedInUser")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for errors
            if let error = error {
                print(error)
                return
            }
            
            // Get HTTP Response
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(User.self, from: data)
                    completionHander(response)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func getUser(username: String, completionHander: @escaping (User) -> Void) {
        let url = URL(string: "http://104.236.83.241/api/users/getUser/\(username)")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        // Http request body
       
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for errors
            if let error = error {
                print(error)
                return
            }
            
            // Get HTTP Response
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(User.self, from: data)
                    completionHander(response)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func createAccount(email: String, username: String, password: String, completionHandler: @escaping (Confirmation) -> Void) {
        
        let url = URL(string: "http://104.236.83.241/api/users/register")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // Parameters to be used for http request
        let body = "email=\(email)&username=\(username)&password=\(password)"
        
        // Http request body
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for errors
            if let error = error {
                print(error)
                return
            }
            
            // Print http response
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(Confirmation.self, from: data)
                    completionHandler(response)
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    func logIn(username: String, password: String, completionHandler: @escaping (Confirmation) -> Void) {
        
        let url = URL(string: "http://104.236.83.241/api/users/login")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // Parameters to be used for http request
        let body = "username=\(username)&password=\(password)"
        
        print("made it TO ")
        // Http request body
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for errors
            if let error = error {
                print(error)
                return
            }
            
            // Print http response
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(Confirmation.self, from: data)
                    completionHandler(response)
                    
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func logout(completionHandler: @escaping (Confirmation) -> Void) {
        let url = URL(string: "http://104.236.83.241/api/users/logout")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
         
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(Confirmation.self, from: data)
                    completionHandler(response)
                    
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    
}
