//
// Created by Vlad Hatko on 4/30/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import Parse

class Lector: PFObject, PFSubclassing {
    public static func parseClassName() -> String {
        return "Lector"
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

    var mail: String? {
        get {
            return objectForKey("mail") as? String
        }
        set(newName) {
            if newName != nil {
                setObject(newName!, forKey: "mail")
            }
        }
    }

    var lessons: [BaseLesson]? {
        get {
            return objectForKey("lessons") as? [BaseLesson]
        }
        set(newLessons) {
            if newLessons != nil {
                setObject(newLessons!, forKey: "lessons")
            }
        }
    }
}
