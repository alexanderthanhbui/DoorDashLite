//
//  RestaurantListViewModel.swift
//  DoorDashLite
//
//  Created by Alexander Bui on 9/9/19.
//  Copyright © 2019 Alexander Bui. All rights reserved.
//

import Foundation

class RestaurantListViewModel {
    
    private var apiService: APIService?
        
    private var cellViewModels: [RestaurantListCellViewModel] = [RestaurantListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadTableViewClosure: (()->())?

    // MARK: - Constructor
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    // MARK: - Network call
    func initFetch(latitude: Double, longitude: Double) {
        self.apiService?.requestFetchRestaurant(latitude: latitude, longitude: longitude, completionHandler: { (restaurants, error) in
            if let error = error {
                print(error)
            }
            if let restaurants = restaurants {
                self.processFetchedRestaurant(restaurants: restaurants)
            }
        })
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> RestaurantListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( restaurant: Restaurant ) -> RestaurantListCellViewModel {
        
        return RestaurantListCellViewModel( name: restaurant.name,
                                            description: restaurant.description,
                                            coverImgURL: restaurant.coverImgUrl,
                                            deliveryFee: restaurant.deliveryFee )
    }
    
    private func processFetchedRestaurant( restaurants: [Restaurant] ) {
        var vms = [RestaurantListCellViewModel]()
        for restaurant in restaurants {
            vms.append( createCellViewModel(restaurant: restaurant) )
        }
        self.cellViewModels = vms
    }
    
}

struct RestaurantListCellViewModel {
    let name: String
    let description: String
    let coverImgURL: String
    let deliveryFee: Int
}
