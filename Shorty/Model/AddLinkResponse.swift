//
//  AddLinkResponse.swift
//  Shorty
//
//  Created by Mattia Sanfilippo on 18/04/2020.
//  Copyright © 2020 Mattia Sanfilippo. All rights reserved.
//

import Foundation

struct AddLinkResponse: Codable {
    let hashid: String
    let url: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case hashid
        case url
        case createdAt = "created_at"
    }
}

