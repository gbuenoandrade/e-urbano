//
//  MyHistoriesVC.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import UIKit
import Parse

class MyHistories: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var historiesAuthorLabel: UILabel!
	
	var historiesAndComments: [(History,[Comment]?)]?
	
	override func viewWillAppear(animated: Bool) {
		let app = UIApplication.sharedApplication()
		app.networkActivityIndicatorVisible = true
		updateHistoriesAuthor()
		Util.runClosuresOnBackgroundAndMain({ () -> Void in
			self.historiesAndComments = [(History,[Comment]?)]()
			let histories: [History]? = Database.getHistoriesOfAuthorSynchronously(PFUser.currentUser()?.username)
			if let histories = histories {
				for history in histories {
					let comments = Database.getCommentsOfHistorySynchronously(history.objectId)
					let newItem: (History,[Comment]?) = (history, comments)
					self.historiesAndComments?.append(newItem)
				}
			}
			}, mainClosure: { () -> Void in
			self.tableView.reloadData()
			app.networkActivityIndicatorVisible = false
		})
	}
	
	func updateHistoriesAuthor() {
		var newAuthor: String?
		Util.runClosuresOnBackgroundAndMain({ () -> Void in
			newAuthor = Database.getNameOfCurrentUser()
		}, mainClosure: { () -> Void in
			if newAuthor != nil {
				self.historiesAuthorLabel.text = "Histórias de " + newAuthor!
			}
		})
	}

}

extension MyHistories: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if historiesAndComments != nil {
			return historiesAndComments!.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let identifier = "cell"
		var cell = self.tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
		}
		
		if historiesAndComments != nil && historiesAndComments!.count > indexPath.row {
			let auxItem: (History,[Comment]?)? = historiesAndComments?[indexPath.row]
			let history = auxItem?.0
			let comments = auxItem?.1
			cell!.textLabel?.text = history?.title
			var numComments = 0
			if comments != nil {
				numComments = comments!.count
			}
			if numComments == 1 {
				cell!.detailTextLabel?.text = "1 comentário"
			}
			else {
				cell!.detailTextLabel?.text = String(numComments) + " comentários"
			}
		}
		
		return cell!
	}
}
