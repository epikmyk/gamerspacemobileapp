//
//  GameResponses.swift
//  gamerspace
//
//  Created by Michael Morales on 5/10/21.
//

import Foundation

struct GameService {
    
    var rawgAPIKey = "09da1e9cbb9b49f5982d84dcd0cbcf55"
   
    func getGames(completionHander: @escaping (GameFeed) -> Void) {
        let url = URL(string: "https://api.rawg.io/api/games?key=\(rawgAPIKey)")
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
                    let response = try decoder.decode(GameFeed.self, from: data)
                    completionHander(response)
                } catch {
                    print("catch error")
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func search(searchTerm: String, completionHander: @escaping (GameFeed) -> Void) {
        let url = URL(string: "https://api.rawg.io/api/games?key=\(rawgAPIKey)&search=\(searchTerm)")
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
                    let response = try decoder.decode(GameFeed.self, from: data)
                    completionHander(response)
                } catch {
                    print("catch error")
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func addFavoriteGame(slug: String, name: String, image: String, completionHandler: @escaping (Confirmation) -> Void) {
        
        let url = URL(string: "http://104.236.83.241/api/games/addGame")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        print("\(slug)")
        print("\(name)")
        print("\(image)")
        // Parameters to be used for http request
        let body = "slug=\(slug)&name=\(name)&image=\(image)"
        
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
    
    func getFavoriteGames(username: String, completionHander: @escaping ([GameDetail]) -> Void) {
        let url = URL(string: "http://104.236.83.241/api/games/getFavoriteGames/\(username)")
        guard let requestUrl = url else { fatalError()}
        var request = URLRequest(url: requestUrl)
        //request.addValue("Client-ID: 4zqb31s928lpqyh3c9j75a0ggaezy4", forHTTPHeaderField: "application/vnd.twitchtv.v5+json")
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
                    let response = try decoder.decode([GameDetail].self, from: data)
                    completionHander(response)
                } catch {
                    print("catch error")
                    print(error)
                }
            }
        }
        task.resume()
    }
}
