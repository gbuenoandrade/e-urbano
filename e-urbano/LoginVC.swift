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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		view.addGestureRecognizer(tapGestureRecognizer)
		
		if let user = PFUser.currentUser() {
			if user.isAuthenticated() {
				print("fala meu bom, \(Database.getNameOfCurrentUser())!")
			}
		}
	}
	
	@IBAction func logInPressed(sender: AnyObject) {
		PFUser.logInWithUsernameInBackground(userTextField.text, password: passwordTextField.text) { (user, error) -> Void in
			if user != nil {
				print("fala meu bom, \(Database.getNameOfCurrentUser())!")
			}
			else if let error = error {
				self.showErrorView(error)
			}
		}
	}
	
}