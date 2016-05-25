//
// Created by Vlad Hatko on 3/31/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import Parse
import Alamofire

class WebserviceManager {
    static let sharedInstance = WebserviceManager()
    private let rootUrlString = "http://451c42a4.ngrok.io/parse"

    init() {
        let configuration = ParseClientConfiguration {
            $0.applicationId = "journalApi"
            $0.clientKey = "journalApi"
            $0.server = self.rootUrlString
        }
        Parse.initializeWithConfiguration(configuration)

        BaseLesson.registerSubclass()
        Lector.registerSubclass()
        Discipline.registerSubclass()
        Student.registerSubclass()
        Group.registerSubclass()
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

        query.findObjectsInBackgroundWithBlock{
            (objectsArray: [PFObject]?, error: NSError?) -> Void in
            var allLessons = [BaseLesson]()

            if error == nil && objectsArray != nil {
                allLessons = objectsArray as! [BaseLesson]
            }

            completion(allLessons, error)

            //MARK: temp

            var idx = 0

            for lesson in allLessons {
                lesson.numberOfLesson = idx
                idx = idx + 1
            }

            Lector.saveAllInBackground(allLessons){
                (success: Bool, error: NSError?) -> Void in

            }
        }
    }

    func login(mail: String, pass: String, completion: LoginResultBlock) -> Void {
        PFCloud.callFunctionInBackground("login", withParameters: ["mail": mail, "pass": pass], block: {
            (lector: AnyObject?, error: NSError?) in
            completion(lector as? Lector, error)
        })
    }
}

typealias LessonsArrayResultBlock = ([BaseLesson]?, NSError?) -> Void
typealias LoginResultBlock = (Lector?, NSError?) -> Void
