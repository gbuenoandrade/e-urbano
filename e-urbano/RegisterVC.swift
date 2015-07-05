//
//  RegisterVC.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import UIKit
import Parse

class RegisterVC: UIViewController {
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	var parentVC: LoginVC?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		view.addGestureRecognizer(tapGestureRecognizer)
	}
	
	@IBAction func backPressed(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func signUpPressed(sender: AnyObject) {
		let user = PFUser()
		user.username = usernameTextField.text
		user.password = passwordTextField.text
		user.email = emailTextField.text
		
		user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
			if succeeded {
				Database.setNameForCurrentUser(self.nameTextField.text)
				self.parentVC!.setAlreadyLoggedInToTrue()
				self.dismissViewControllerAnimated(false, completion:nil)
			}
			else if let error = error {
				self.showErrorView(error)
			}
		}
	}
	
}
