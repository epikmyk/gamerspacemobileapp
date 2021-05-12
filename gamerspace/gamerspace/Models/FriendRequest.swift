//
//  FriendRequest.swift
//  gamerspace
//
//  Created by Michael Morales on 5/11/21.
//

import Foundation

struct Friend: Codable {
    var status: Int
}

struct FriendRequest: Codable {
    var status: Int
    var user_id: Int
    var friend_id: Int
    var username: String
    var created: String
}
