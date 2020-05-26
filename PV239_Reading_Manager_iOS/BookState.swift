//
//  BookState.swift
//  PV239_Reading_Manager_iOS
//
//  Created by Patrik Pluhař on 04/04/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

enum BookState: String, CaseIterable, Codable {
    case unread = "Unread"
    case reading = "Reading"
    case readed = "Readed"
    case notOwned = "Not Owned"
    
    var description: String {
        get {
            return self.rawValue
        }
    }
}
