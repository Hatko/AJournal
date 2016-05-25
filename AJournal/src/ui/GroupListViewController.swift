//
// Created by Vlad Hatko on 5/7/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import UIKit

class GroupListViewController: UITableViewController {
//    let tempSource = [Lesson(date: NSDate(), room: "SomeRoom", group: "525"), Lesson(date: NSDate(), room: "SomeRoom2", group: "530")]


    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tempSource.count
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lLessonCellID", forIndexPath: indexPath)

//        cell.textLabel!.text = tempSource[indexPath.row].group

        return cell
    }
}
