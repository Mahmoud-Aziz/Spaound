
import Foundation


struct SpaoundUser {
    let firstName:String
    let lastName:String
    let emailAddress:String
    let phoneNumber:String

    var safeEmail:String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
    }
}

struct UserInfo {
    var firstName = ""
    var lastName = ""
    var phoneNumber:String? = ""
}

