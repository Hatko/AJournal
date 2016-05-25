//
// Created by Vlad Hatko on 5/8/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import Parse

class Group: PFObject, PFSubclassing {
    public static func parseClassName() -> String {
        return "Group"
    }

    var name: String? {
        get {
            return objectForKey("name") as? String
        }
        set(newName) {
            if newName != nil {
                setObject(newName!, forKey: "name")
            }
        }
    }

    var students: [Student]? {
        get {
            return objectForKey("students") as? [Student]
        }
        set(newStudents) {
            if newStudents != nil {
                setObject(newStudents!, forKey: "students")
            }
        }
    }
}