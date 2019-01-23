//
//  Auth.swift
//  Clerkie Hridayam Bakshi Coding Challenge
//
//  Created by hridayam bakshi on 1/22/19.
//  Copyright © 2019 hridayam bakshi. All rights reserved.
//

import Foundation
import CoreData
import KeychainAccess

class Auth {
    #warning ("TODO: fix the definition of user and userLoggedIn")
    static var email: String? = nil
    static var password: String? = nil
    
    static var userLoggedIn: status = .notLoggedIn
    
    enum status {
        case notRegistered
        case incorrectPassword
        case loggedIn
        case notLoggedIn
    }
    
    fileprivate static let keychain = Keychain(service: APP_ID)
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func registerUser(email: String, password: String) {
        
        let newUser = Users(context: self.context)
        newUser.email = email
        newUser.password = password
        
        do {
            try self.context.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    #warning ("TODO: fix login")
    static func login(email: String, password: String, cb: (status) -> Void) {
        let request: NSFetchRequest<Users> = Users.fetchRequest()
        
        let predicate = NSCompoundPredicate(
            type: .and,
            subpredicates: [
                NSPredicate(format: "email = '\(email)'"),
                //NSPredicate(format: "password = '\(password)'")
            ]
        )
        request.predicate = predicate
        
        do {
            let users = try context.fetch(request)
            
            if users.count > 0 {
                for data in users {
                    if data.password == password {
                        try self.keychain.set(email, key: "email")
                        try self.keychain.set(password, key: "password")
                        self.email = data.email
                        self.password = data.password
                        userLoggedIn = .loggedIn
                        
                        break
                    } else {
                        userLoggedIn = .incorrectPassword
                    }
                }
            } else {
                userLoggedIn = .notRegistered
            }
            cb(userLoggedIn)
        } catch {
            print("error fetching data from context \(error)")
            userLoggedIn = .notLoggedIn
            cb(userLoggedIn)
        }
    }
    
    static func autoLogin(cb: (status) -> Void) {
        do {
            userLoggedIn = .notLoggedIn
            guard let email = try self.keychain.getString("email") else {
                cb(userLoggedIn)
                return
            }
            guard let password = try self.keychain.getString("password") else {
                cb(userLoggedIn)
                return
            }
            
            self.email = email
            self.password = password
            userLoggedIn = .loggedIn
        } catch {
            print("error fetching data from context \(error)")
        }
        cb(userLoggedIn)
    }
    
    static func logout(cb: (status) -> Void) {
        do {
            try keychain.remove("email")
            try keychain.remove("password")
            email = nil
            password = nil
            userLoggedIn = .notLoggedIn
        } catch let error {
            print("error: \(error)")
        }
        
        cb(userLoggedIn)
    }
}

