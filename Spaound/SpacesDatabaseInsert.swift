
import Foundation
import FirebaseDatabase

class spacesDatabaseInsert {
    
    static let shared = spacesDatabaseInsert()
    
    func insertSpaces() {
        
        
        SpacesDatabaseManager.shared.insertSpace(with: Space(spaceName: "spaceOne", spaceDistrict: "NasrCity", spaceStreetName: "Makram Ebeid", freeWiFi: true, booksLibrary: true, coffee: true, meetingRoom: true, aboutSpace: "The most comfort and quiet Co-Working Space in Nasr City With Affordable Price", pricePerDay: 25, pricePerDayMeetingRoom: 50, pricePerDaySmallRoom: 30, pricePerDayGamesRoom: 40, pricePerDaySharedSpace: 20, facebookLink: "", whatsAppNumber: 0, contactNumber: 0))
        
        SpacesDatabaseManager.shared.insertSpace(with: Space(spaceName: "spaceTwo", spaceDistrict: "NasrCity", spaceStreetName: "Makram Ebeid", freeWiFi: true, booksLibrary: true, coffee: true, meetingRoom: true, aboutSpace: "The most comfort and quiet Co-Working Space in Nasr City With Affordable Price", pricePerDay: 25, pricePerDayMeetingRoom: 50, pricePerDaySmallRoom: 30, pricePerDayGamesRoom: 40, pricePerDaySharedSpace: 20, facebookLink: "", whatsAppNumber: 0, contactNumber: 0))
        
        SpacesDatabaseManager.shared.insertSpace(with: Space(spaceName: "spaceThree", spaceDistrict: "NasrCity", spaceStreetName: "Makram Ebeid", freeWiFi: true, booksLibrary: true, coffee: true, meetingRoom: true, aboutSpace: "The most comfort and quiet Co-Working Space in Nasr City With Affordable Price", pricePerDay: 25, pricePerDayMeetingRoom: 50, pricePerDaySmallRoom: 30, pricePerDayGamesRoom: 40, pricePerDaySharedSpace: 20, facebookLink: "", whatsAppNumber: 0, contactNumber: 0))
    }
}
