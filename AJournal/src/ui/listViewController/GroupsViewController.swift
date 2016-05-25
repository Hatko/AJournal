//
// Created by Vlad Hatko on 4/20/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import UIKit

class GroupsViewController: UITableViewController {
    let groups = ["525", "526", "527", "528", "529", "530"]


    //MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("lGroupToViewSegueID", sender: nil)
    }


    //MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lGroupCell", forIndexPath: indexPath) as! StudentCell

        cell.chargeWithStudentName(groups[indexPath.row])

        return cell
    }
}
