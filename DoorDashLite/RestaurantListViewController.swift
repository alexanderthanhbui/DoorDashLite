//
//  RestaurantListViewController.swift
//  DoorDashLite
//
//  Created by Alexander Bui on 9/9/19.
//  Copyright © 2019 Alexander Bui. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class RestaurantListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var chosenAddress: CLLocationCoordinate2D?
    
    // MARK: - Injection
    let viewModel = RestaurantListViewModel(apiService: APIService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        // Init the static view
        initView()
        
        // init view model
        initVM()
    }
    
    func initView() {
        tableView.estimatedRowHeight = 99.5
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initVM() {
        // Naive binding
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch(latitude: chosenAddress?.latitude ?? 0, longitude: chosenAddress?.longitude ?? 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension RestaurantListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCellIdentifier", for: indexPath) as? RestaurantListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.restaurantListCellViewModel = cellVM
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99.5
    }
    
}

class RestaurantListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var asapTimeLabel: UILabel!
    
    var restaurantListCellViewModel : RestaurantListCellViewModel? {
        didSet {
            if let name = restaurantListCellViewModel?.name {
                nameLabel.text = name
            }
            if let description = restaurantListCellViewModel?.description {
                descriptionLabel.text = description
            }
            if let deliveryFee = restaurantListCellViewModel?.deliveryFee {
                if deliveryFee == 0 {
                    deliveryFeeLabel.text = "Free"
                } else {
                    deliveryFeeLabel.text = String(deliveryFee)
                }
            } else {
                deliveryFeeLabel.text = "Free"
            }
            if let asapTime = restaurantListCellViewModel?.asapTime {
                asapTimeLabel.text = "\(asapTime) min"
            }
            coverImageView?.sd_setImage(with: URL( string: restaurantListCellViewModel?.coverImgURL ?? "" ), completed: nil)
        }
    }
    
}
