//
//  LoginVC.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController {
	
	@IBOutlet weak var userTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	var alreadyLoggedIn = false
	var registerVCSegue = "goToRegisterScreen"
	
	func setAlreadyLoggedInToTrue() {
		alreadyLoggedIn = true
	}
	
	override func viewWillAppear(animated: Bool) {
		if alreadyLoggedIn {
			self.dismissViewControllerAnimated(false, completion: nil)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		alreadyLoggedIn = false
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		view.addGestureRecognizer(tapGestureRecognizer)
		let user = PFUser.currentUser()
		if user != nil && user!.isAuthenticated() {
			self.dismissViewControllerAnimated(false, completion: nil)
		}
	}
	
	@IBAction func logInPressed(sender: AnyObject) {
		PFUser.logInWithUsernameInBackground(userTextField.text, password: passwordTextField.text) { (user, error) -> Void in
			if user != nil {
				self.dismissViewControllerAnimated(false, completion: nil)
			}
			else if let error = error {
				self.showErrorView(error)
			}
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == registerVCSegue {
			let registerVC = segue.destinationViewController as! RegisterVC
			registerVC.parentVC = self
		}
			
	}
	
}