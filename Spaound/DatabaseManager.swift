
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
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    ///inserts new user to database
    public func insertUser(with user:SpaoundUser) {
        database.child(user.safeEmail).setValue ([
            
            "first_name":user.firstName,
            "last_name":user.lastName,
            "phone_number":user.phoneNumber ?? 0
            //no need to put email because it's the child value because it's the unique one
        ])
    }
}

struct SpaoundUser {
    let firstName:String
    let lastName:String
    let emailAddress:String
    let phoneNumber:Int?
    
    var safeEmail:String {
        
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
    }
}





