//
// Created by Vlad Hatko on 5/29/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditDataViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }

    private func elementsForSection(section: Int) -> [PFObject] {
        return section == 0 ? DataManager.sharedInstance.allGroups! : UserManager.sharedInstance.userLessons!
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2// lessons & groups
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Groups" : "Lessons"
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementsForSection(section).count + 1
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete {
            (elementsForSection(indexPath.section)[indexPath.row] as! PFObject).deleteInBackground()

            tableView.beginUpdates()
            if indexPath.section == 0 {
                DataManager.sharedInstance.allGroups!.removeAtIndex(indexPath.row)
            } else {
                UserManager.sharedInstance.userLessons!.removeAtIndex(indexPath.row)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lGroupCell", forIndexPath: indexPath) as! UITableViewCell

        cell.selectionStyle = .None

        let elementsForSection = self.elementsForSection(indexPath.section)

        if indexPath.row < elementsForSection.count {
            cell.textLabel!.text = indexPath.section == 0 ? (elementsForSection as! [Group])[indexPath.row].name : (elementsForSection as! [BaseLesson])[indexPath.row].discipline!.name
            cell.textLabel!.textColor = UIColor.blackColor()
        } else {
            cell.textLabel!.text = "Add new"
            cell.textLabel!.textColor = UIColor(red: 0.00, green: 0.48, blue:1.00, alpha:1.00)
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(indexPath.section == 0 ? "lAddNewGroup" : "lAddNewLesson",
                sender: indexPath.row < elementsForSection(indexPath.section).count ? elementsForSection(indexPath.section)[indexPath.row] : nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lAddNewGroup" && sender != nil {
            (segue.destinationViewController as! AddGroupViewController).group = (sender as! Group)
        } else if segue.identifier == "lAddNewLesson" && sender != nil {
            (segue.destinationViewController as! AddLessonViewController).lesson = (sender as! BaseLesson)
        }
    }
}
