//
// Created by Vlad Hatko on 6/5/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    class func showSimpleMessage(message: String, fromController controller: UIViewController){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))

        controller.presentViewController(alert, animated: true, completion: nil)
    }
}
