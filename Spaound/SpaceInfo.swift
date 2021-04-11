
import Foundation

struct SpaceInfo:Codable {
    let spaceName:String?
    let spaceDistrict:String?
    let spaceStreetName:String?
    let freeWiFi:Bool?
    let booksLibrary:Bool?
    let coffee:Bool?
    let meetingRoom:Bool?
    let gamingRoom:Bool?
    let aboutSpace:String?
    let pricePerDay:Int?
    let pricePerDayMeetingRoom:Int?
    let pricePerDaySmallRoom:Int?
    let pricePerDayGamesRoom:Int?
    let pricePerDaySharedSpace:Int?
    let facebookLink:String?
    let whatsAppNumber:String?
    let contactNumber:String?
}
