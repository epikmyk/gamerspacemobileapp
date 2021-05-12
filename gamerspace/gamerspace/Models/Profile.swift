//
//  Profile.swift
//  gamerspace
//
//  Created by Michael Morales on 5/11/21.
//

import Foundation

struct Profile {
    var username: String
    var user_id: Int
    
    init(username: String, user_id: Int) {
        self.username = username
        self.user_id = user_id
    }
}
