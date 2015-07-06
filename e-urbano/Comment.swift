//
//  Comment.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/5/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import Foundation
import Parse

class Comment: PFObject {
	@NSManaged var textContent: String?
	@NSManaged var authorUsername: String?
	@NSManaged var authorName: String?
	@NSManaged var historyID: String?
	
	override init() {
		super.init()
	}
	
	override class func query() -> PFQuery? {
		let query = PFQuery(className: Comment.parseClassName())
		return query
	}
	
}

extension Comment: PFSubclassing {
	class func parseClassName() -> String {
		return "Comment"
	}
	
	override class func initialize() {
		var onceToken: dispatch_once_t = 0
		dispatch_once(&onceToken) {
			self.registerSubclass()
		}
	}
}