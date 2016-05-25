//
// Created by Vlad Hatko on 5/3/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import Parse

class BaseLesson: PFObject, PFSubclassing {
    public static func parseClassName() -> String {
        return "BaseLesson"
    }

    var room: String? {
        get {
            return objectForKey("room") as? String
        }
        set(newRoom) {
            if newRoom != nil {
                setObject(newRoom!, forKey: "room")
            }
        }
    }

    var lector: Lector? {
        get {
            return objectForKey("lector") as? Lector
        }
        set(newLector) {
            if newLector != nil {
                setObject(newLector!, forKey: "lector")
            }
        }
    }

    var discipline: Discipline? {
        get {
            return objectForKey("discipline") as? Discipline
        }
        set(newDiscipline) {
            if newDiscipline != nil {
                setObject(newDiscipline!, forKey: "discipline")
            }
        }
    }

    var groups: [Group]? {
        get {
            return objectForKey("groups") as? [Group]
        }
        set(newGroups) {
            if newGroups != nil {
                setObject(newGroups!, forKey: "groups")
            }
        }
    }
}


typealias RepeatedLesson = BaseLesson
extension RepeatedLesson {
    var dayOfWeek: Int? {
        get {
            return objectForKey("dayOfWeek") as? Int
        }
        set(newDayOfWeek) {
            if newDayOfWeek != nil {
                setObject(newDayOfWeek!, forKey: "dayOfWeek")
            }
        }
    }

    var dayOfWeekVerbal: String? {
        switch dayOfWeek! {
            case 0:
                return "Monday"
            case 1:
                return "Tuesday"
            case 2:
                return "Wednesday"
            case 3:
                return "Thursday"
            case 4:
                return "Friday"
            case 5:
                return "Saturday"
            case 6:
                return "Sunday"
            default:
                return nil
        }
    }

    var numberOfLesson: Int? {
        get {
            return objectForKey("numberOfLesson") as? Int
        }
        set(numberOfLesson) {
            if numberOfLesson != nil {
                setObject(numberOfLesson!, forKey: "numberOfLesson")
            }
        }
    }
}


typealias SingleLesson = BaseLesson
extension SingleLesson {
    var date: NSDate? {
        get {
            return objectForKey("date") as? NSDate
        }
        set(newDate) {
            if newDate != nil {
                setObject(newDate!, forKey: "date")
            }
        }
    }
}
