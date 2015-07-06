//
//  InsertHistoryVC.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MapKit
import MobileCoreServices

class InsertHistoryVC: UIViewController {

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var addressTextView: UITextView!
	@IBOutlet weak var titleTextField: UITextField!

	var coordinate: CLLocationCoordinate2D?
	
	let historyPlaceHolderText = "Insira aqui sua história"
	let addressPlaceHolderText = "Clique aqui para o inserir o endereço"

	let imagePicker = UIImagePickerController()
	let findAddressSegue = "goToFindAddressScreen"
	
	@IBOutlet weak var selectImageButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		view.addGestureRecognizer(tapGestureRecognizer)
		
		changeAdressTextView(addressPlaceHolderText)
		
		self.textView.text = self.historyPlaceHolderText
		textView.textColor = UIColor.lightGrayColor()
		
	}
	
	func changeAdressTextView(newText: String?) {
		self.addressTextView.text = newText
		self.addressTextView.font = UIFont.italicSystemFontOfSize(18.0)
		self.addressTextView.textColor = UIColor.lightGrayColor()
		self.addressTextView.textAlignment = NSTextAlignment.Center
	}
	
	@IBAction func selectImagePressed(sender: AnyObject) {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
			imagePicker.allowsEditing = false
			self.presentViewController(imagePicker, animated: true, completion: nil)
		}
	}
	
	
	@IBAction func insertPressed(sender: AnyObject) {
		let app = UIApplication.sharedApplication()
		app.networkActivityIndicatorVisible = true
		let history = History()
		history.title = self.titleTextField.text
		history.textContent = self.textView.text
		history.printableAddress = self.addressTextView.text
		if let coord = self.coordinate {
			history.latitude = NSNumber(double: coord.latitude)
			history.longitude = NSNumber(double: coord.longitude)
		}
		if let image = self.imageView.image {
			history.imageFile = PFFile(data: UIImagePNGRepresentation(image))
		}
		Util.runClosuresOnBackgroundAndMain({ () -> Void in
			history.authorName = Database.getNameOfCurrentUser()
			
		}, mainClosure: { () -> Void in
			history.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
				app.networkActivityIndicatorVisible = false
				if succeeded {
					self.dismissViewControllerAnimated(true, completion: nil)
				}
				else if let error = error{
					self.showErrorView(error)
				}
			})
		})
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == findAddressSegue {
			if let nextVC = segue.destinationViewController as? FindAddressVC {
				nextVC.parentVC = self
			}
		}
	}
	
	
	@IBAction func backPressed(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}

extension InsertHistoryVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		
		self.dismissViewControllerAnimated(true, completion: { () -> Void in
			self.imageView.image = image
			self.selectImageButton.hidden = true
		})
		
	}
}

extension InsertHistoryVC: UITextViewDelegate {
	
	func textViewDidBeginEditing(textView: UITextView) {
		if textView.text == historyPlaceHolderText {
			textView.text = ""
			textView.textColor = UIColor.blackColor()
		}
		textView.becomeFirstResponder()
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		if textView.text == "" {
			textView.text = historyPlaceHolderText
			textView.textColor = UIColor.lightGrayColor()
		}
	}
	
}