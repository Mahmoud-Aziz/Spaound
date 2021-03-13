

import Foundation
import FirebaseDatabase

final class SpacesDatabaseManager {
    
    static let shared = SpacesDatabaseManager()
    private let database = Database.database().reference()

}

//MARK: -Space Info Management

extension SpacesDatabaseManager {
    
    public func sort() {
        
        database.child("spaound-f249d-default-rtdb").queryOrdered(byChild: "spaceOne").queryEqual(toValue: "Makram Ebeid").observeSingleEvent(of: .value, with: { snapshot in
            var array:[SpaceInfo] = []
            for i in snapshot.children {
                let spaceSnap = i as! DataSnapshot
                let spaceDic = spaceSnap.value as! [String:String]
                var space = SpaceInfo()
                space.spaceStreetName = spaceDic["spaceStreetName"]!
                print("spaaace \(space.spaceName)")
                array.append(space)
                print(array)
                
                
            }
        })
    }
    
    public func insertSpace(with space: Space) {
        
        database.child(space.spaceName).setValue([
            
            "name": space.spaceName,
            "spaceDistrict": space.spaceDistrict,
            "spaceStreetName": space.spaceStreetName,
            "freeWiFi": space.freeWiFi,
            "bookLibrary":space.booksLibrary,
            "coffee": space.coffee,
            "meetingRoom": space.meetingRoom,
            "aboutSpace": space.aboutSpace,
            "pricePerDay": space.pricePerDay,
            "pricePerDayMeetingRoom": space.pricePerDayMeetingRoom,
            "pricePerDaySmallRoom": space.pricePerDaySmallRoom,
            "pricePerDayGamesRoom": space.pricePerDayGamesRoom,
            "pricePerDaySharedSpace": space.pricePerDaySharedSpace,
            "facebookLink": space.facebookLink,
            "whatsAppNumber": space.whatsAppNumber,
            "contactNumber": space.contactNumber,
            
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("failed to write to database")
                return
            }
            
            self.database.child("spaces").observeSingleEvent(of: .value, with: { snapshot in
                if var spacesCollection = snapshot.value as? [[String:Any]] {
                    //append to user dictionary
                    let newElement = [
                        "name": space.spaceName,
                        "spaceDistrict": space.spaceDistrict,
                        "spaceStreetName": space.spaceStreetName,
                        "freeWiFi": space.freeWiFi,
                        "bookLibrary":space.booksLibrary,
                        "coffee": space.coffee,
                        "meetingRoom": space.meetingRoom,
                        "aboutSpace": space.aboutSpace,
                        "pricePerDay": space.pricePerDay,
                        "pricePerDayMeetingRoom": space.pricePerDayMeetingRoom,
                        "pricePerDaySmallRoom": space.pricePerDaySmallRoom,
                        "pricePerDayGamesRoom": space.pricePerDayGamesRoom,
                        "pricePerDaySharedSpace": space.pricePerDaySharedSpace,
                        "facebookLink": space.facebookLink,
                        "whatsAppNumber": space.whatsAppNumber,
                        "contactNumber": space.contactNumber,
                    ] as [String : Any]
                    spacesCollection.append(newElement)
                    self.database.child("spaces").setValue(spacesCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            return
                        }
                        
                    }) 
                }
                else {
                    //create the array
                    let newCollection: [[String:Any]] = [[
                        "name": space.spaceName,
                        "spaceDistrict": space.spaceDistrict,
                        "spaceStreetName": space.spaceStreetName,
                        "freeWiFi": space.freeWiFi,
                        "bookLibrary":space.booksLibrary,
                        "coffee": space.coffee,
                        "meetingRoom": space.meetingRoom,
                        "aboutSpace": space.aboutSpace,
                        "pricePerDay": space.pricePerDay,
                        "pricePerDayMeetingRoom": space.pricePerDayMeetingRoom,
                        "pricePerDaySmallRoom": space.pricePerDaySmallRoom,
                        "pricePerDayGamesRoom": space.pricePerDayGamesRoom,
                        "pricePerDaySharedSpace": space.pricePerDaySharedSpace,
                        "facebookLink": space.facebookLink,
                        "whatsAppNumber": space.whatsAppNumber,
                        "contactNumber": space.contactNumber,
                    ]]
                    self.database.child("spaces").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            return
                        }
                    })
                }
            })
    })
    }
    public func retrieveSpace(with spaceName:String,completion: @escaping ((SpaceInfo)->Void)) {
        
        database.child(spaceName).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                print("error retrieving data from firebase")
                return
            }
            
            var space = SpaceInfo()
            
            space.spaceName = (value["name"] as? String ?? "no value")
            space.spaceDistrict = (value["spaceDistrict"] as? String ?? "no value")
            space.spaceStreetName = (value["spaceStreetName"] as? String ?? "no value")
            space.freeWiFi = (value["freeWiFi"] as? Bool ?? true)
            space.booksLibrary = (value["bookLibrary"] as? Bool ?? true)
            space.coffee = (value["coffee"] as? Bool ?? true)
            space.meetingRoom = (value["meetingRoom"] as? Bool ?? true)
            space.aboutSpace = (value["aboutSpace"] as? String ?? "no value")
            space.pricePerDay = (value["pricePerDay"] as? Int ?? 0)
            space.pricePerDayMeetingRoom = (value["pricePerDayMeetingRoom"] as? Int ?? 0)
            space.pricePerDaySmallRoom = (value["pricePerDaySmallRoom"] as? Int ?? 0)
            space.pricePerDayGamesRoom = (value["pricePerDayGamesRoom"] as? Int ?? 0)
            space.pricePerDaySharedSpace = (value["pricePerDaySharedSpace"] as? Int ?? 0)
            space.facebookLink = (value["facebookLink"] as? String ?? "no value")
            space.whatsAppNumber = (value["whatsAppNumber"] as? Int ?? 0)
            space.contactNumber = (value["contactNumber"] as? Int ?? 0)
            
            completion(space)
    
        })
        
    }
    
}


struct Space {
    let spaceName:String
    let spaceDistrict:String
    let spaceStreetName:String
    let freeWiFi:Bool
    let booksLibrary:Bool
    let coffee:Bool
    let meetingRoom:Bool
    let aboutSpace:String
    let pricePerDay:Int
    let pricePerDayMeetingRoom:Int
    let pricePerDaySmallRoom:Int
    let pricePerDayGamesRoom:Int
    let pricePerDaySharedSpace:Int
    let facebookLink:String
    let whatsAppNumber:Int
    let contactNumber:Int
}

struct SpaceInfo {
    var spaceName = ""
    var spaceDistrict = ""
    var spaceStreetName = ""
    var freeWiFi = true
    var booksLibrary = true
    var coffee = true
    var meetingRoom = true
    var aboutSpace = ""
    var pricePerDay = 0
    var pricePerDayMeetingRoom = 0
    var pricePerDaySmallRoom = 0
    var pricePerDayGamesRoom = 0
    var pricePerDaySharedSpace = 0
    var facebookLink = ""
    var whatsAppNumber = 0
    var contactNumber = 0
}





