//
//  FindAdressPin.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

//import Foundation
import MapKit

class FindAdressAnnotation: NSObject, MKAnnotation {
	var title: String = "oi"
	var subtitle: String = "tchau"
	var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
	override init() {
		super.init()
	}
	
}

