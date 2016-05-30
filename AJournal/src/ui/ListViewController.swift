//
// Created by Vlad Hatko on 4/15/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    
    private var groups : [Group]? = []
    private var selectedCells = Set<Int>()

    private let fakeStudents = ["Mike", "Kevin", "Jule", "Stiven", "Ban"]

    override func viewDidLoad() {
        super.viewDidLoad()

        groups = (parentViewController as! CheckTabController).lesson!.groups
    }


    // MARK: UITableViewDataSource

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return groups!.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeStudents.count//groups![section].students!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lStudentCell", forIndexPath:indexPath) as! StudentCell

        cell.selectionStyle = .None

        if selectedCells.contains(indexPath.row) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        let group = groups![indexPath.section]
        let studentName = fakeStudents[indexPath.row]//(group.students![indexPath.row] as! Student).name!

        if cell.nameLabel.text != studentName {
            cell.nameLabel.text = studentName
        }

        return cell
    }


    //MARK: UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedCells.contains(indexPath.row) {
            selectedCells.remove(indexPath.row)
            tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .None
        } else {
            tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark
            selectedCells.insert(indexPath.row)
        }
    }
}
