//
//  History.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/5/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class History {
	var title: String
	var content: String?
	var image: UIImage!
//	var coordinate: CLLocationCoordinate2D
	
	
	init(title: String, content: String?, image: UIImage?, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.content = content
		self.image = image
//		self.coordinate = coordinate
	}
}