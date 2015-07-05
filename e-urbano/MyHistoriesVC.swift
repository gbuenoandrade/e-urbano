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

	@IBOutlet weak var historiesAuthorLabel: UILabel!
	
	override func viewWillAppear(animated: Bool) {
		updateHistoriesAuthor()
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
