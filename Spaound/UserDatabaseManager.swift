
import Foundation
import FirebaseDatabase
import FirebaseAuth

final class UserDatabaseManager {
    
    static let shared = UserDatabaseManager()
    
    private let database = Database.database().reference()
    
}

//MARK: -Account Management

extension UserDatabaseManager {
    
    //methods deal with database are asyncronous
    public func userExists(with email:String, completion: @escaping ((Bool)->Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    public func userInfo(with email:String, completion: @escaping ((UserInfo)->Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                return
            }
            var user = UserInfo()
            user.firstName = value["first_name"] as! String
            user.lastName = value["last_name"] as! String
            user.phoneNumber = value["phone_number"] as! Int
            
            completion(user)
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
    
    var profilePicturUrl:String {
        //mahmoud-gmail-com_profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
    
    var safeEmail:String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
    }
}

    struct UserInfo {
        var firstName = ""
        var lastName = ""
        var phoneNumber = 0
    }







