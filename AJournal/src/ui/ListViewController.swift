//
// Created by Vlad Hatko on 4/15/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!
    
    private var groups : [Group]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        groups = (parentViewController as! CheckTabController).lesson!.groups
    }


    // MARK: UITableViewDataSource

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return groups!.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups![section].students!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lStudentCell", forIndexPath:indexPath) as! StudentCell

        let group = groups![indexPath.section]
        let student = group.students![indexPath.row]

        cell.chargeWithStudentName((student as! Student).name!)

        return cell
    }
}
