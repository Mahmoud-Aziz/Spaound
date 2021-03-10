
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
    
    
    public func insertSpaceInfo(with info:SpaceInfo,completion: @escaping (Bool) -> Void) {
        
        database.child("spaces").setValue([
            
            "price": info.pricePerDay,
            "name": info.spaceName
           
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            
            self.database.child("spaces").observeSingleEvent(of: .value, with: { snapshot in
                if var spacesCollection = snapshot.value as? [[String:Any]] {
                    //append to spaces dictionary
                    let newElement = [
                        "price": info.pricePerDay,
                        "name": info.spaceName
                    ] as [String : Any]
                    
                    spacesCollection.append(newElement)
                    
                    self.database.child("spaces").setValue(spacesCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            return
                        }
                        completion(true)
                    })
                }
                else {
                    //create the array
                    let newCollection: [[String:String]] =
                        
                        [
                            [
                                "name": info.spaceName,
                                "price": String(info.pricePerDay)
                            ]
                        ]
                    
                    self.database.child("spaces").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            return
                        }
                    })
                }
            })
        }
        
        )
    }
    
//    public func spaceInfoRetrieve(with name:String, completion: @escaping (([Space]) -> Void))  {
//
//
//
//        database.child(name).observe(.value, with: { snapshot in
//            guard let value = snapshot.value as? [String: Any] else {
//
//                return
//            }
//
//            price = value["price"] as! Int
//
//
//            print("value is \(value) name is \(name)")
//        })
//    }
    



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



  struct SpaceInfo {
    let spaceName:String
    let pricePerDay:Int
}







