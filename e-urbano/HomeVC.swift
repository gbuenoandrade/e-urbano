//
//  HomeVC.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import UIKit
import Parse

class HomeVC: UIViewController {
	
	let logInScreenSegue = "goToLogInScreen"
	let settingsScreenSegue = "goToSettingsScreen"
	
	override func viewDidAppear(animated: Bool) {
		let user = PFUser.currentUser()
		if user == nil || !user!.isAuthenticated() {
			self.performSegueWithIdentifier(self.logInScreenSegue, sender: nil)
		}
	}
	
}
