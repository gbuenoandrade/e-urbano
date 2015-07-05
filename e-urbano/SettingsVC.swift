//
//  SettingsVC.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import UIKit
import Parse

class SettingsVC: UIViewController {
	
	var parentVC: HomeVC?
	
	@IBAction func userChangePressed() {
		PFUser.logOut()
		dismissViewControllerAnimated(false, completion: nil)
	}
	
	@IBAction func backPressed() {
		dismissViewControllerAnimated(true, completion: nil)
	}
}
