//
//  Post.swift
//  gamerspace
//
//  Created by Michael Morales on 5/11/21.
//

import Foundation

struct Post: Codable {
    var post_id: Int
    var post: String
    var created: String
    var user_poster_id: Int
    var user_receiver_id: Int
    var username: String
}

struct gamerspacePost {
    var username: String
    var post: String
    var index: Int
    var hasImage: Bool
    var imageIndex: Int
}
