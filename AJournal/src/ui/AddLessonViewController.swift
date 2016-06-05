//
// Created by Vlad Hatko on 6/5/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

class AddLessonViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roomTextField: UITextField!
    @IBOutlet weak var disciplineTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewWithPickerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lessonTextField: UITextField!

    var lesson = BaseLesson()

    override func viewDidLoad() {
        super.viewDidLoad()

        roomTextField.text = lesson.room
        disciplineTextField.text = lesson.discipline != nil ? lesson.discipline!.name : ""
        dayTextField.text = lesson.dayOfWeek != nil ? "\(lesson.dayOfWeek)" : ""
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (lesson.groups != nil ? lesson.groups!.count : 0) + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lLessonCell", forIndexPath: indexPath)

        cell.selectionStyle = .None

        if lesson.groups == nil || indexPath.row == lesson.groups!.count {
            cell.textLabel!.text = "Add"
            cell.textLabel!.textColor = UIColor(red: 0.00, green: 0.48, blue:1.00, alpha:1.00)
        } else {
            cell.textLabel!.text = lesson.groups![indexPath.row].name
            cell.textLabel!.textColor = UIColor.blackColor()
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if DataManager.sharedInstance.allGroups!.count == 0 {
            UIAlertController.showSimpleMessage("You don't have no groups. Add at least one at first", fromController: self)

            return
        }

        if lesson.groups == nil || indexPath.row == lesson.groups!.count {
            hidePicker(false)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataManager.sharedInstance.allGroups!.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DataManager.sharedInstance.allGroups![row].name!
    }

    private func hidePicker(hide: Bool){
        view.layoutIfNeeded()

        bottomConstraint.constant = hide ? 0 : viewWithPickerView.frame.height

        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func addGroup(sender: UIButton) {
        if self.lesson.groups == nil {
            self.lesson.groups = [Group]()
        }

        let group = DataManager.sharedInstance.allGroups![pickerView.selectedRowInComponent(0)]

        if self.lesson.groups!.contains(group){
            return
        }

        hidePicker(true)

        self.tableView.beginUpdates()
        self.lesson.groups!.insert(group, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
    }

    func saveButtonTapped(sender: AnyObject) {
        if roomTextField.text != nil && !roomTextField.text!.isEmpty && lessonTextField.text != nil && !lessonTextField.text!.isEmpty && disciplineTextField.text != nil &&
                !disciplineTextField.text!.isEmpty && dayTextField.text != nil && !dayTextField.text!.isEmpty && lesson.groups != nil && !lesson.groups!.isEmpty {
            let spinner = SwiftSpinner.show("Saving your lesson...")

            lesson.lector = UserManager.sharedInstance.currentLector
            lesson.room = roomTextField.text

            let discipline = Discipline()
            discipline.name = disciplineTextField.text

            lesson.discipline = discipline
            lesson.dayOfWeek = Int(dayTextField.text!)
            lesson.numberOfLesson = Int(lessonTextField.text!)

            lesson.saveInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in

                if success {
                    spinner.titleLabel.text = "Retreiving all data..."

                    WebserviceManager.sharedInstance.getLessonsWithCompletion{
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
            UIAlertController.showSimpleMessage("Provide all missing information", fromController: self)
        }
    }
}
