//
//  APIService.swift
//  DoorDashLite
//
//  Created by Alexander Bui on 9/10/19.
//  Copyright © 2019 Alexander Bui. All rights reserved.
//

import Foundation
import Alamofire

struct APIService {
    
    // MARK: - Singleton
    static let shared = APIService()
        
    // MARK: - URL
    private var photoUrl = "https://api.doordash.com/v1/store_search/"
    
    // MARK: - Services
    mutating func requestFetchRestaurant(latitude: Double, longitude: Double, completionHandler: @escaping ([Restaurant]?, Error?) -> ()) {
        let url = "\(photoUrl)?lat=\(latitude)&lng=\(longitude)"
        
        Alamofire.request(url, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                guard let data = response.data else { return }
                do{
                    let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                    completionHandler(restaurants, nil)
                }
                catch{}
            }
        }
    }
    
}
