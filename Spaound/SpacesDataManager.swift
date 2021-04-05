

import Foundation
import FirebaseDatabase

final class SpacesDatabaseManager {
    
    var spaces = [[String:Any]]()

    static let shared = SpacesDatabaseManager()
    private let database = Database.database().reference()
    
   
    
}

//MARK: -Space Info Management

extension SpacesDatabaseManager {
    
    
    public func getAllSpaces(completion: @escaping (Result<[[String:Any]], Error>) -> Void) {
        
        database.child("spaces").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String:Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            completion(.success(value))
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
    
    public func retrieveSpace(completion: @escaping ((SpaceInfo)->Void)) {
        
        database.child("spaces").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let value = snapshot.value as? [[String:Any]] else {
                print("error retrieving data from firebase")
                return
            }
            
            self?.spaces = value
            UserDefaults.standard.setValue(self?.spaces, forKey: "spaces")
            
            var space = SpaceInfo()
            
            let index = Int.random(in: 0...1)
            let first = value[index]
            
            space.spaceName = (first["name"] as? String ?? "no value")
            space.spaceDistrict = (first["spaceDistrict"] as? String ?? "no value")
            space.spaceStreetName = (first["spaceStreetName"] as? String ?? "no value")
            space.freeWiFi = (first["freeWiFi"] as? Bool ?? true)
            space.booksLibrary = (first["bookLibrary"] as? Bool ?? true)
            space.coffee = (first["coffee"] as? Bool ?? true)
            space.meetingRoom = (first["meetingRoom"] as? Bool ?? true)
            space.gamingRoom = (first["gamingRoom"] as? Bool ?? true)
            space.aboutSpace = (first["aboutSpace"] as? String ?? "no value")
            space.pricePerDay = (first["pricePerDay"] as? Int ?? 0)
            space.pricePerDayMeetingRoom = (first["pricePerDayMeetingRoom"] as? Int ?? 0)
            space.pricePerDaySmallRoom = (first["pricePerDaySmallRoom"] as? Int ?? 0)
            space.pricePerDayGamesRoom = (first["pricePerDayGamesRoom"] as? Int ?? 0)
            space.pricePerDaySharedSpace = (first["pricePerDaySharedSpace"] as? Int ?? 0)
            space.facebookLink = (first["facebookLink"] as? String ?? "no value")
            space.whatsAppNumber = (first["whatsAppNumber"] as? Int ?? 0)
            space.contactNumber = (first["contactNumber"] as? Int ?? 0)
            
            completion(space)
            
        })
        
    }
}
