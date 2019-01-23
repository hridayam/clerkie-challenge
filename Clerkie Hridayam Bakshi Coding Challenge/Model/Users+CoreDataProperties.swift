//
//  Users+CoreDataProperties.swift
//  Clerkie Hridayam Bakshi Coding Challenge
//
//  Created by hridayam bakshi on 1/21/19.
//  Copyright © 2019 hridayam bakshi. All rights reserved.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var email: String
    @NSManaged public var password: String

}
