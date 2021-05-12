//
//  FriendResponses.swift
//  gamerspace
//
//  Created by Michael Morales on 5/7/21.
//

import Foundation

struct FriendResponses {
    func getFriendStatus(username: String, friendUsername: String, completionHander: @escaping (Friend) -> Void) {
        print("USER IS \(username)")
        print("WE MADE it here \(friendUsername)")
        let url = URL(string: "http://104.236.83.241/api/friends/getFriendStatus/\(username)/\(friendUsername)")
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
                    let response = try decoder.decode(Friend.self, from: data)
                    completionHander(response)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func getFriendRequests(completionHander: @escaping ([FriendRequest]) -> Void) {
        let url = URL(string: "http://104.236.83.241/api/friends/getFriendRequests")
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
                    let response = try decoder.decode([FriendRequest].self, from: data)
                    completionHander(response)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func friendRequest(friend_id: Int, completionHandler: @escaping (Confirmation) -> Void) {
        
        let url = URL(string: "http://104.236.83.241/api/friends/addFriend")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // Parameters to be used for http request
        let body = "friend_id=\(friend_id)"
        
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
    
    func acceptFriendRequest(user_id: Int, friend_id: Int, completionHandler: @escaping (Confirmation) -> Void) {
        
        let url = URL(string: "http://104.236.83.241/api/friends/acceptFriendRequest")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // Parameters to be used for http request
        let body = "user_id=\(user_id)&friend_id=\(friend_id)"
        
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
    func deleteFriend(user_id: Int, friend_id: Int, completionHandler: @escaping (Confirmation) -> Void) {
        
        let url = URL(string: "http://104.236.83.241/api/friends/declineFriendRequest/\(user_id)/\(friend_id)")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        
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
    

}
