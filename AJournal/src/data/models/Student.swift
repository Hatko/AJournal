//
// Created by Vlad Hatko on 5/3/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import Parse

class Student: PFObject, PFSubclassing {
    public static func parseClassName() -> String {
        return "Student"
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

    var group: Group? {
        get {
            return objectForKey("group") as? Group
        }
        set(newGroup) {
            if newGroup != nil {
                setObject(newGroup!, forKey: "group")
            }
        }
    }
}
