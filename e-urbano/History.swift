//
//  History.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/5/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import Foundation
import Parse

class History: PFObject {
	@NSManaged var title: String?
	@NSManaged var authorName: String?
	@NSManaged var imageFile: PFFile?
	@NSManaged var textContent: String?
	@NSManaged var latitude: NSNumber?
	@NSManaged var longitude: NSNumber?
	@NSManaged var printableAddress: String?
	
	func getImageSynchronously() -> UIImage? {
		if let data = imageFile?.getData() {
			return UIImage(data: data)
		}
		return nil
	}
	
	func createImageFileFromImage(image: UIImage!) {
		let data = UIImagePNGRepresentation(image)
		self.imageFile = PFFile(data: data)
	}
	
	override init() {
		super.init()
	}
	
	override class func query() -> PFQuery? {
		let query = PFQuery(className: History.parseClassName())
		return query
	}
	
	
}

extension History: PFSubclassing {
	class func parseClassName() -> String {
		return "History"
	}
	
	override class func initialize() {
		var onceToken: dispatch_once_t = 0
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
}