//
//  UIViewControllerExtension.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {

	func showErrorView(error: NSError) {
		let errorMessage = error.userInfo?["error"] as? String
		let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
		presentViewController(alert, animated: true, completion: nil)
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}

}
