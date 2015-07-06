//
//  Database.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import Foundation
import Parse

class Database {
	
	class func setNameForCurrentUser(name: String) {
		let user = PFUser.currentUser()
		if let user = user {
			let userIdentification = PFObject(className: "UserIdentification")
			userIdentification.setObject(user.username!, forKey: "username")
			userIdentification.setObject(name, forKey: "name")
			userIdentification.saveEventually()
		}
	}
	
	class func getNameOfCurrentUser() -> String? {
		let user = PFUser.currentUser()
		if let user = user {
			let query = PFQuery(className: "UserIdentification")
			query.whereKey("username", equalTo: user.username!)
			let objectsArray: [PFObject]? = query.findObjects() as? [PFObject]
			let userIdentification = objectsArray?.first
			if userIdentification != nil {
				return userIdentification?["name"] as? String
			}
		}
		return nil
	}
	
	class func getCommentsOfHistorySynchronously(historyID: String?) -> [Comment]? {
		if historyID == nil {
			return nil
		}
		else {
			let query = Comment.query()
			query?.whereKey("historyID", equalTo: historyID!)
			query?.orderByDescending("updatedAt")
			if let objects = query?.findObjects() as? [Comment] {
				return objects
			}
		}
		return nil
	}
	
	class func getHistoriesOfAuthorSynchronously(authorUsername: String?) -> [History]? {
		if let authorUsername = authorUsername {
			let query = History.query()
			query?.whereKey("authorUsername", equalTo: authorUsername)
			query?.orderByDescending("updatedAt")
			if let objects = query?.findObjects() as? [History] {
				return objects
			}
		}
		return nil
	}
	
	class func getAllHistoriesSynchronously() -> [History]? {
		let query = History.query()
		if let objects = query?.findObjects() as? [History] {
			return objects
		}
		return nil
	}
}