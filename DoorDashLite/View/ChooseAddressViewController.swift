//
//  ChooseAddressViewController.swift
//  DoorDashLite
//
//  Created by Alexander Bui on 9/9/19.
//  Copyright © 2019 Alexander Bui. All rights reserved.
//

import UIKit
import MapKit

class ChooseAddressViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var confirmAddressButton: UIButton!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        mapView.showsUserLocation = true

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        // Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
        } else {
        // Choose DoorDash HQ as default location if location not available
            let doorDashLocation = CLLocationCoordinate2DMake(37.783470, -122.408043)
            let viewRegion = MKCoordinateRegion(center: doorDashLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // authorized location status when app is in use; update current location
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Remove all annotations
        self.mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.centerCoordinate
        self.mapView.addAnnotation(annotation)

        // Update Address Label
        lookUpCenterLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude) { (address) in
            DispatchQueue.main.async {
                self.addressLabel.text = address
            }
        }
    }
    
    func lookUpCenterLocation(latitude: Double, longitude: Double, completionHandler: @escaping (String?)
        -> Void ) {
        // Use the center location.
        let centerLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
            
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(centerLocation, completionHandler: { (placemarks, error) in
            if error == nil {
                var address = ""
                let placeMark = placemarks?[0]
                // Street address
                if let subStreet = placeMark?.subThoroughfare {
                    address.append("\(subStreet) ")
                }
                // Street address
                if let street = placeMark?.thoroughfare {
                    address.append("\(street) ")
                }
                completionHandler(address)
            } else {
                // An error occurred during geocoding.
                completionHandler(nil)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a variable that you want to send
        let centerCoordinates = mapView.centerCoordinate
        
        // Create a new variable to store the instance of PlayerTableViewController
        let tabBarController: UITabBarController = segue.destination as! UITabBarController
        let destinationVC = tabBarController.viewControllers![0] as! RestaurantListViewController
        destinationVC.chosenAddress = centerCoordinates
    }
    
}
