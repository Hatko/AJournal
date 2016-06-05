//
// Created by Vlad Hatko on 6/5/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

class AddGroupViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var group = Group()

    override func viewDidLoad() {
        super.viewDidLoad()

        groupNameTextField.text = group.name
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (group.students != nil ? group.students!.count : 0) + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lStudentCell", forIndexPath: indexPath)

        cell.selectionStyle = .None

        if group.students == nil || indexPath.row == group.students!.count {
            cell.textLabel!.text = "Add"
            cell.textLabel!.textColor = UIColor(red: 0.00, green: 0.48, blue:1.00, alpha:1.00)
        } else {
            cell.textLabel!.text = group.students![indexPath.row].name
            cell.textLabel!.textColor = UIColor.blackColor()
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if group.students == nil || indexPath.row == group.students!.count {
            let alert = UIAlertController(title: nil, message: "Enter student name", preferredStyle: .Alert)

            var textField = UITextField()

            alert.addTextFieldWithConfigurationHandler{
                (alertTextField: UITextField) -> Void in
                textField = alertTextField
            }

            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
                (action: UIAlertAction) -> Void in
                let student = Student()

                student.name = textField.text

                self.tableView.beginUpdates()
                if self.group.students == nil {
                    self.group.students = [Student]()
                }
                self.group.students!.append(student)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: 0)], withRowAnimation: .Automatic)
                self.tableView.endUpdates()
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))

            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func saveButtonTapped(sender: UIBarButtonItem) {
        if groupNameTextField.text != nil && groupNameTextField.text!.characters.count > 0 && group.students != nil && group.students!.count > 0 {
            let spinner = SwiftSpinner.show("Saving your group...")

            group.name = groupNameTextField.text

            group.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if success {
                    spinner.titleLabel.text = "Retreiving all data..."

                    WebserviceManager.sharedInstance.fetchAllGroupsWithCompletion{
                        (error: NSError?) -> Void in
                        if error != nil {
                            UIAlertController.showSimpleMessage("Error occured:\(error!.description)", fromController: self)
                        } else {
                            self.navigationController!.popViewControllerAnimated(true)
                            (self.navigationController!.topViewController! as! EditDataViewController).tableView.reloadData()
                        }

                        SwiftSpinner.hide()
                    }
                } else {
                    if error != nil {
                        UIAlertController.showSimpleMessage("Error occured:\(error!.description)", fromController: self)
                    }
                }
            }
        } else {
            UIAlertController.showSimpleMessage("Enter your group name and add at least one student to proceed", fromController: self)
        }
    }
}
