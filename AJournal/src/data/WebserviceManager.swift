//
// Created by Vlad Hatko on 3/31/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import Parse
import Alamofire

class WebserviceManager {
    static let sharedInstance = WebserviceManager()
    private var rootUrlString = "http://980f3cf0.ngrok.io/parse"
    private var parseSetUp = false

    init() {
        BaseLesson.registerSubclass()
        Lector.registerSubclass()
        Discipline.registerSubclass()
        Student.registerSubclass()
        Group.registerSubclass()
    }

    func setUpParse() {
        if parseSetUp {
            return
        }

        let configuration = ParseClientConfiguration {
            $0.applicationId = "journalApi"
            $0.clientKey = "journalApi"
            $0.server = self.rootUrlString
        }
        Parse.initializeWithConfiguration(configuration)

        parseSetUp = true
    }

    func setNewRootURLString(newString: String){
        rootUrlString = newString
    }

    //
    // result will be stored in DataManager
    func fetchAllGroupsWithCompletion(completion: FetchGroupsResultBlock){
        let query = PFQuery(className: Group.parseClassName())

        query.includeKey("students")

        query.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil && objects!.count > 0 {
                DataManager.sharedInstance.allGroups = objects as! [Group]
            }

            completion(error: error)
        }
    }
    //

    func fetchAllStudentsForLesson(lesson: BaseLesson, withCompletion completion: FetchResultBlock){
        var dispatchGroup = dispatch_group_create()

        var errors = [NSError]()

        for group in lesson.groups! {
            dispatch_group_enter(dispatchGroup)

            (group as! Group).fetchIfNeededInBackgroundWithBlock {
                (resultObject: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    errors.append(error!)
                }

                if group.students != nil {
                    for student in group.students! {

                        (student as! Student).fetchIfNeededInBackgroundWithBlock {
                            (resultObject: PFObject?, error: NSError?) -> Void in
                            if error != nil {
                                errors.append(error!)
                            }

                            dispatch_group_leave(dispatchGroup)
                        }
                    }
                }
            }
        }

        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), {
            completion(errors: errors)
        })
    }

    func getLessonsWithCompletion(completion: LessonsArrayResultBlock) {
        let query = PFQuery(className: BaseLesson.parseClassName())

        query.whereKey("lector", equalTo: UserManager.sharedInstance.currentLector!)
        query.orderByAscending("dayOfWeek")
        query.orderByAscending("numberOfLesson")

        //
        // fetching all disciplines, so we could use them right away
        query.includeKey("discipline")
        //

        query.includeKey("groups")

        query.findObjectsInBackgroundWithBlock{
            (objectsArray: [PFObject]?, error: NSError?) -> Void in
            var allLessons = [BaseLesson]()

            if error == nil && objectsArray != nil {
                allLessons = objectsArray as! [BaseLesson]
            }

            //temp

            for lesson in allLessons {
                lesson.fetchIfNeededInBackground()
                if lesson.groups != nil {
                    for group in lesson.groups! {
                        group.fetchInBackground()

                        if group.students != nil {
                            for student in group.students! {
                                student.fetchIfNeededInBackground()
                            }
                        }
                    }
                }
                if lesson.discipline != nil {
                    lesson.discipline!.fetchIfNeededInBackground()
                }
            }

            //

            UserManager.sharedInstance.userLessons = allLessons

            completion(error)
        }
    }

    func login(mail: String, pass: String, completion: LoginResultBlock) -> Void {
        PFCloud.callFunctionInBackground("login", withParameters: ["mail": mail, "pass": pass], block: {
            (lector: AnyObject?, error: NSError?) in
            completion(lector as? Lector, error)
        })
    }
}

typealias LessonsArrayResultBlock = (NSError?) -> Void
typealias LoginResultBlock = (Lector?, NSError?) -> Void
typealias FetchResultBlock = (errors: [NSError]?) -> Void
typealias FetchGroupsResultBlock = (error: NSError?) -> Void
