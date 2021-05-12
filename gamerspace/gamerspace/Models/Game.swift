//
//  Game.swift
//  gamerspace
//
//  Created by Michael Morales on 5/11/21.
//

import Foundation

struct GameFeed: Codable {
    var results:[GameDetail]
}

struct GameDetail: Codable {
    var slug: String?
    var name:String?
    var background_image: String?
}

struct Game: Codable {
    var slug: String?
    var name:String?
}

struct GameModel {
    let slug: String
    let text: String
    let image: String
    
    init(slug: String, text: String, image: String) {
        self.slug = slug
        self.text = text
        self.image = image
    }
}
