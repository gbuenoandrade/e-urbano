//
//  FindAddressVC.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

//import Foundation
import UIKit
import MapKit

class FindAdressVC: UIViewController {

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var addressTextField: UITextField!
		
	let regionRadiusZoom: CLLocationDistance = 800 // in meters
	let locationManager = CLLocationManager()
	let app = UIApplication.sharedApplication()
	
	override func viewDidLoad() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		view.addGestureRecognizer(tapGestureRecognizer)
		
		let lpgr = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
		lpgr.minimumPressDuration = 1.0
		self.mapView.addGestureRecognizer(lpgr)
		
		self.mapView.showsUserLocation = true
		self.mapView.mapType = .Hybrid
		
		locationManagerSetup()
	}
	
	func insertPointAtCoordinateWithTitle(coordinate: CLLocationCoordinate2D, title: String) {
		self.mapView.removeAnnotations(self.mapView.annotations)
		let findAddAnot = FindAdressAnnotation()
		findAddAnot.title = title
		findAddAnot.coordinate = coordinate
		self.mapView.addAnnotation(findAddAnot)
	}
	
	func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
		if gestureRecognizer.state != UIGestureRecognizerState.Began {
			return
		}
		let touchPoint = gestureRecognizer.locationInView(self.mapView)
		let touchMapCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
		app.networkActivityIndicatorVisible = true
		getPrintableAddressFromCoordinateWithCompletion(touchMapCoordinate, completition: { (printableAddress) -> Void in
			self.app.networkActivityIndicatorVisible = false
			self.addressTextField.text = printableAddress
			self.insertPointAtCoordinateWithTitle(touchMapCoordinate, title: printableAddress)
		})
	}
	
	func locationManagerSetup() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = .infinity
		locationManager.startUpdatingLocation()
	}
	
	@IBAction func backPressed() {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func findPressed() {
		app.networkActivityIndicatorVisible = true
		let localSearchRequest = MKLocalSearchRequest()
		localSearchRequest.naturalLanguageQuery = addressTextField.text
		let localSearch = MKLocalSearch(request: localSearchRequest)
		localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
			if localSearchResponse == nil {
				self.app.networkActivityIndicatorVisible = false
				self.showErrorView(error)
			}
			else {
				let coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude: localSearchResponse.boundingRegion.center.longitude)
				self.dismissKeyboard()
				self.getPrintableAddressFromCoordinateWithCompletion(coordinate, completition: { (printableAddress) -> Void in
					self.addressTextField.text = printableAddress
					self.insertPointAtCoordinateWithTitle(coordinate, title: printableAddress)
					self.mapView.centerMapOnLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), regionRadius: self.regionRadiusZoom)
					self.app.networkActivityIndicatorVisible = false
				})
			}
		}
	}
	
	func getPrintableAddressFromCoordinateWithCompletion(coordinate: CLLocationCoordinate2D, completition: (printableAddress: String) -> Void) {
		var printableAddress = ""
		let geocorder = CLGeocoder()
		geocorder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: { (placemarks, error) -> Void in
			let placeArray = placemarks as? [CLPlacemark]
			var placeMark: CLPlacemark!
			placeMark = placeArray?[0]
			if let street = placeMark.addressDictionary["Name"] as? String {
				printableAddress += street + ". "
			}
			if let city = placeMark.addressDictionary["City"] as? String {
				printableAddress += city + ". "
			}
			if let country = placeMark.addressDictionary["Country"] as? String {
				printableAddress += country
			}
			completition(printableAddress: printableAddress)
		})
	}
	
}

extension FindAdressVC: MKMapViewDelegate {
	
	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		if let annotation = annotation as? FindAdressAnnotation {
			let identifier = "findPin"
			var view: MKPinAnnotationView
			if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
				dequeuedView.annotation = annotation
				view = dequeuedView
			}
			else {
				view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//				view.canShowCallout = true
//				view.calloutOffset = CGPoint(x: -5, y: -5)
//				view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
			}
			
			view.animatesDrop = true
			view.draggable = true
			return view
		}
		return nil
	}
	
	func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
		if newState == .Ending {
			let coordinate = CLLocationCoordinate2D(latitude: view.annotation.coordinate.latitude, longitude: view.annotation.coordinate.longitude)
			self.getPrintableAddressFromCoordinateWithCompletion(coordinate, completition: { (printableAddress) -> Void in
				self.addressTextField.text = printableAddress
			})
		}
	}
}

extension FindAdressVC: CLLocationManagerDelegate {
	
	func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
		self.mapView.centerMapOnLocation(newLocation, regionRadius: regionRadiusZoom)
		locationManager.stopUpdatingLocation()
	}
}
