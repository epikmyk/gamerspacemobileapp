//
//  PostResponses.swift
//  gamerspace
//
//  Created by Michael Morales on 5/4/21.
//

import Foundation

struct PostService {
    
    func getUserPostsAndFriendsPosts(callback: @escaping ([Post]) -> Void) {
        let url = URL(string: "https://gamerspace.gg/api/posts/getUserPostsAndFriendsPosts")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for errors
            if let error = error {
                print("request error")
                print(error)
                return
            }
            
            // Print http response
            if let data = data {
                
                let decoder = JSONDecoder()
                print("this is data \(data)")
                print("decoding json")
                do {
                    let response = try decoder.decode([Post].self, from: data)
                    callback(response)
                } catch {
                    print("catch error")
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func getUserPosts(username: String, completionHandler: @escaping ([Post]) -> Void) {
        let url = URL(string: "https://gamerspace.gg/api/posts/getRecentPostsToUser/\(username)")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
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
                    let response = try decoder.decode([Post].self, from: data)
                    completionHandler(response)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func createPost(post: String, image: String, userReceiverId: Int, completionHandler: @escaping (Confirmation) -> Void) {
        let url = URL(string: "https://gamerspace.gg/api/posts/createPost")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // Parameters to be used for http request
        var body: [String: Any]
        /*
        if html == "" {
            body = ["post": "\(post)" ,"user_receiver_id":"\(userReceiverId)"]
            
        }
        else {
            body = ["post": "\(html)", "user_receiver_id":"\(userReceiverId)"]
        }*/
        
        print("POST IS: \(post)")
        body = ["post": "\(post)", "image":"\(image)" , "user_receiver_id":"\(userReceiverId)"]
        
        
        request.httpBody = body.percentEncoded()
        
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
