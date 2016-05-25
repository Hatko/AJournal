//
// Created by Vlad Hatko on 5/7/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation

class UserManager {
    static let sharedInstance = UserManager()

    var currentLector: Lector? = nil
    var userLessons: [BaseLesson]? = nil
}
