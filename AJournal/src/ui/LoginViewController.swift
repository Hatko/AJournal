//
//  LoginViewController.swift
//  AJournal
//
//  Created by Vlad Hatko on 3/31/16.
//  Copyright © 2016 Hatcom. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner

class LoginViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

//        WebserviceManager.sharedInstance.login("test@gmail.com", pass: "")

        nameTextField.text = "cherednichenko@gmail.com"
        passTextField.text = "1111"

//
//        WebserviceManager.sharedInstance

//        let lector = Lector()
//        lector.name = "Vlad"
//        lector.mail = "vladhatko@gmail.com"
//        lector.setObject(md5(string: "1111"), forKey: "pass")
//
//        lector.saveInBackgroundWithBlock({
//            (success: Bool, error: NSError?) -> Void in
//
//        })


    }

    private func md5(string string: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }

        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }

        return digestHex
    }

//        WebserviceManager.sharedInstance
//        let lector = Lector()
//        lector.name = "Artem"
//        lector.mail = "cherednichenko@gmail.com"
//        lector.setObject(md5(string: "1111"), forKey: "pass")
//        UserManager.sharedInstance.currentLector = lector

    @IBAction func loginButtonTapped(sender: UIButton) {
        if nameTextField.text?.characters.count > 0 && passTextField.text?.characters.count > 0 {
            if nameTextField.text == "set custom address" {
                WebserviceManager.sharedInstance.setNewRootURLString(passTextField.text!)

                let alert = UIAlertController(title: nil, message: "Changed addres", preferredStyle: .Alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))

                presentViewController(alert, animated: true, completion: nil)

                return
            }

            let spinner = SwiftSpinner.show("Connecting to satellite...")

            WebserviceManager.sharedInstance.setUpParse()

            WebserviceManager.sharedInstance.login(nameTextField.text!, pass: md5(string: passTextField.text!)) {
                (lector: Lector?, error: NSError?) -> Void in

                //
                // save temp lesson

//                PFQuery(className: Lector.parseClassName()).findObjectsInBackgroundWithBlock{
//                    (lectors: [PFObject]?, error: NSError?) -> Void in
//                    let discipline = Discipline()
//                    discipline.name = "Mathematics"
//
//                    let student = Student()
//                    student.name = "Dujiy"
//
//                    let group = Group()
//                    group.name = "990 Z"
//                    group.students = [student]
//
//                    let lesson = RepeatedLesson()
//                    lesson.lector = lectors!.first as! Lector
//                    lesson.discipline = discipline
//                    lesson.groups = [group]
//                    lesson.dayOfWeek = 0 //0..6
//                    lesson.room = "110"
//
//                    lesson.saveInBackgroundWithBlock {
//                        (success: Bool, error: NSError?) -> Void in
//
//                    }
//                }


                //



                if lector != nil {
                    spinner.titleLabel.text = "Retrieving your data..."

                    UserManager.sharedInstance.currentLector = lector

                    WebserviceManager.sharedInstance.getLessonsWithCompletion{
                        (lessons: [BaseLesson]?, error: NSError?) -> Void in

                        if error != nil {
                            print("error occured:\(error!.description)")
                        }

                        UserManager.sharedInstance.userLessons = lessons

                        self.performSegueWithIdentifier("lLoginToScheduleSegueID", sender: nil)

                        SwiftSpinner.hide()
                    }
                } else {
                    //error handling
                    SwiftSpinner.hide()
                }
            }
        } else {
            let alert = UIAlertController(title: nil, message: "Provide your mail and password", preferredStyle: .Alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))

            presentViewController(alert, animated: true, completion: nil)
        }
    }
}
