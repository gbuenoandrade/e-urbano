//
//  MapVC.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
	
	@IBOutlet weak var mapView: MKMapView!
	
	var histories: [History]?
	
	
	override func viewDidLoad() {
		self.mapView.mapType = .Hybrid
		self.mapView.showsUserLocation = true
	}
	
	override func viewWillAppear(animated: Bool) {
		Util.runClosuresOnBackgroundAndMain({ () -> Void in
			self.histories = Database.getAllHistoriesSynchronously()
		}, mainClosure: { () -> Void in
			self.clearAnnotations()
			if let histories = self.histories {
				for history in histories {
					if let lat = history.latitude?.doubleValue, long = history.longitude?.doubleValue {
						let annotation = MKPointAnnotation()
						annotation.title = history.title
						annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
						self.mapView.addAnnotation(annotation)
					}
				}
			}
		})
	}
	
	func clearAnnotations() {
		self.mapView.removeAnnotations(self.mapView.annotations)
	}
}

extension MapVC: MKMapViewDelegate {
	
	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		if let annotation = annotation as? MKPointAnnotation {
			let identifier = "pin"
			var view: MKPinAnnotationView
			if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
				dequeuedView.annotation = annotation
				view = dequeuedView
			}
			else {
				view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
				view.canShowCallout = true
				view.calloutOffset = CGPoint(x: -5, y: 5)
				view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
			}
			return view
		}
		return nil
	}
	
	func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
		
	}

}