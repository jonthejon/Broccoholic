//
//  MapViewController.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 11/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

	@IBOutlet weak var infoView: UIView!
	@IBOutlet weak var phoneNumber: UILabel!
	@IBOutlet weak var price: UILabel!
	@IBOutlet weak var rating: UILabel!
	@IBOutlet weak var restaurantName: UILabel!
	@IBOutlet weak var map: MKMapView!
	let locationManager = CLLocationManager()
	var restaurants:[Restaurant] = [Restaurant]()
	var selectedRestaurant: Restaurant?
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.locationManager.requestWhenInUseAuthorization()
		self.map.showsUserLocation = true
		self.locationManager.delegate = self
		self.locationManager.startUpdatingLocation()
        
        infoView.layer.shadowOpacity = 0.7
        infoView.layer.shadowOffset = CGSize(width: 3, height: -10)
        infoView.layer.shadowRadius = 15.0
        infoView.layer.shadowColor = UIColor.darkGray.cgColor
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//		CLLocation *currentLocation = locations[0];
		let currentLocation = locations[0]
//		[self.mapView setRegion:MKCoordinateRegionMake(currentLocation.coordinate, MKCoordinateSpanMake(0.06, 0.06))];
		self.map.setRegion(MKCoordinateRegionMake(currentLocation.coordinate, MKCoordinateSpanMake(0.06, 0.06)), animated: true)
		let apiManager = RecipeAPIManager()
		apiManager.fetchRestaurantsFromYelpApi(location: currentLocation.coordinate, radius: 10000) { (restaurants:[Restaurant]) in
			OperationQueue.main.addOperation({
				self.restaurants = restaurants
				self.map.addAnnotations(self.restaurants)
				self.map.showAnnotations(self.restaurants, animated: true)
			})
		}
//		[NetworkManager yelpSearchWithLocation:currentLocation.coordinate completionHandler:^(NSArray<Cafe *> * cafes) {
//			self.cafes = cafes;
//			[self.mapView addAnnotations:self.cafes];
//			[self.mapView showAnnotations:self.cafes animated:YES];
//			}];
	}
	
//	func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//		self.selectedRestaurant = view.annotation as? Restaurant
//	}
    
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		self.selectedRestaurant = view.annotation as? Restaurant
        self.infoView.isHidden = false
        
		self.handleNewRestaurantClick()
	}
    
    
	
	private func handleNewRestaurantClick() {
		if let restaurant = self.selectedRestaurant {
			self.restaurantName.text = restaurant.title
			self.rating.text = String(restaurant.rating)
			self.phoneNumber.text = restaurant.phone
			self.price.text = restaurant.price
		}
	}
	
	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.infoView.isHidden = true
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Something weird happened here!")
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			self.locationManager.requestLocation()
		}
	}
}
