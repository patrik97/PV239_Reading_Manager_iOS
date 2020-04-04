//
//  User.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

class User {
    private(set) var id: Int
    private(set) var email: String
    private(set) var name: String
    private(set) var password: String
    
    init() {
        id = -1
        email = ""
        name = ""
        password = ""
    }
}
