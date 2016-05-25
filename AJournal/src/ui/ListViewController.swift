//
// Created by Vlad Hatko on 4/15/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!
    
    var names = ["First", "Second", "Third", "Fourth", "Fifth"]

    // MARK: UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lStudentCell", forIndexPath:indexPath) as! StudentCell

        cell.chargeWithStudentName(names[indexPath.row])

        return cell
    }
}
