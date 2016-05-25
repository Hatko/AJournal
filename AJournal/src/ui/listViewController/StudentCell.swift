//
// Created by Vlad Hatko on 4/20/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import UIKit

class StudentCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!

    func chargeWithStudentName(studentName: String) {
        nameLabel.text = studentName
    }
}
