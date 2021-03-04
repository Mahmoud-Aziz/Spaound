//
//  DatabaseManager.swift
//  Spaound
//
//  Created by Mahmoud Aziz on 04/03/2021.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

//MARK: -Account Management

extension DatabaseManager {
    
    //methods deal with database are asyncronous
    public func userExists(with email:String, completion: @escaping ((Bool)->Void)) {
        database.child(email).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    ///inserts new user to database
    public func insertUser(with user:SpaoundUser) {
        database.child(user.emailAddress).setValue ([
            
            "first_name":user.firstName,
            "last_name":user.lastName,
            "phone_number":user.phoneNumber
            //no need to put email because it's the child value because it's the unique one
        ])
    }
}
struct SpaoundUser {
    let firstName:String
    let lastName:String
    let emailAddress:String
    let phoneNumber:Int
}





