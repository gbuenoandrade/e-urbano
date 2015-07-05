//
//  MapViewExtension.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import MapKit

extension MKMapView {
	
	func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2.0, regionRadius*2.0)
		setRegion(coordinateRegion, animated: true)
	}
}
