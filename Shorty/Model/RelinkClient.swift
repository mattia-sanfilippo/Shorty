//
//  RelinkClient.swift
//  Shorty
//
//  Created by Mattia Sanfilippo on 18/04/2020.
//  Copyright © 2020 Mattia Sanfilippo. All rights reserved.
//

import Foundation

class RelinkClient {
    
    enum Endpoints {
        static let base = "https://rel.ink/api"
        static let postNumber = "aaaa"
        
        case addLink
        case getLink
        
        var stringValue: String {
            switch self {
            case .addLink:
                return Endpoints.base + "/links/"
            case .getLink:
                return Endpoints.base + "/links/" + Endpoints.postNumber
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func addLink(longUrl: String, completion: @escaping (String, Error?) -> Void) {
        let body = "{\"url\": \"\(longUrl)\"}"
        RequestHelpers.taskForPOSTRequest(url: Endpoints.addLink.url, responseType: AddLinkResponse.self, body: body, httpMethod: "POST") { (response, error) in
            if let response = response, response.hashid != "" {
                completion(response.hashid, nil)
            }
            completion("", error)
        }
    }
}
