//
//  RestaurantModel.swift
//  DoorDashLite
//
//  Created by Alexander Bui on 9/8/19.
//  Copyright © 2019 Alexander Bui. All rights reserved.
//

import Foundation
import Alamofire

struct Restaurant: Codable {
    let id: Int
    let name: String
    let description: String
    let deliveryFee: Int
    let coverImgUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description = "description"
        case deliveryFee = "delivery_fee"
        case coverImgUrl = "cover_img_url"
    }
}

// MARK: Convenience initializers
extension Restaurant {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Restaurant.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
