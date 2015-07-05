//
//  Util.swift
//  e-urbano
//
//  Created by Guilherme Andrade on 7/4/15.
//  Copyright (c) 2015 Laboratório de Estudos Urbanos da Unicamp. All rights reserved.
//

import Foundation

class Util {
	
	class func runClosuresOnBackgroundAndMain(backClosure: (() -> Void)?, mainClosure: (() -> Void)?) {
		let qualityOfServiceClass = QOS_CLASS_BACKGROUND
		let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
		dispatch_async(backgroundQueue, { () -> Void in
			backClosure?()
			if mainClosure != nil {
				dispatch_async(dispatch_get_main_queue(), mainClosure!)
			}
		})
	}
}
