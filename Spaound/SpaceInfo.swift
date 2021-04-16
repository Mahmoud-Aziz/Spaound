
import Foundation

struct SpaceInfo: Decodable {
    let name: String
    let spaceDistrict: String
    let spaceStreetName: String
    let freeWiFi: Bool
    let bookLibrary: Bool
    let coffee: Bool
    let meetingRoom: Bool
    let gamingRoom: Bool
    let aboutSpace: String
    let pricePerDay: String
    let pricePerDayMeetingRoom: String
    let pricePerDaySmallRoom: String
    let pricePerDayGamesRoom: String
    let pricePerDaySharedSpace: String
    let facebookLink: String
    let whatsAppNumber: String
    let contactNumber: String
}
