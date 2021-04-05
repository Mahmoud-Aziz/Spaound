
import UIKit

class DetailsViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var spaceNameLabel:UILabel!
    @IBOutlet weak var pricePadgeLabel:UILabel! 
    @IBOutlet weak var spaceAddressLabel:UILabel!
    @IBOutlet weak var freeWiFiLabel:UILabel!
    @IBOutlet weak var libraryLabel:UILabel!
    @IBOutlet weak var gameRoomLabel:UILabel!
    @IBOutlet weak var coffeeLabel:UILabel!
    @IBOutlet weak var meetingRoomLabel:UILabel!
    @IBOutlet weak var aboutSpaceLabel:UILabel!
    @IBOutlet weak var priceDayLabel:UILabel!
    @IBOutlet weak var priceMeetingLabel:UILabel!
    @IBOutlet weak var priceSmallLabel:UILabel!
    @IBOutlet weak var priceGamesLabel:UILabel!
    @IBOutlet weak var priceSharedLabel:UILabel!
    @IBOutlet weak var wifiImage:UIImageView!
    @IBOutlet weak var bookImage:UIImageView!
    @IBOutlet weak var meetingImage:UIImageView!
    @IBOutlet weak var gamesImage:UIImageView!
    @IBOutlet weak var coffeeImage:UIImageView!
    @IBOutlet weak var facebookImage:UIImageView! 
    @IBOutlet weak var contactImage:UIImageView!
    @IBOutlet weak var whatsappImage:UIImageView!
    
    
    let spaceName = UserDefaults.standard.value(forKey: "space_name") as? String
    let spaceDistrict = UserDefaults.standard.value(forKey: "space_district") as? String
    let spaceStreet = UserDefaults.standard.value(forKey: "space_street") as? String
    let aboutSpace = UserDefaults.standard.value(forKey: "about_space") as? String
    let spacePriceDay = UserDefaults.standard.value(forKey: "price_per_day") as? Int
    let spacePriceMeeting = UserDefaults.standard.value(forKey: "price_meeting") as? Int
    let spacePriceSmall = UserDefaults.standard.value(forKey: "price_small") as? Int
    let spacePriceGames = UserDefaults.standard.value(forKey: "price_games") as? Int
    let spacePriceShared = UserDefaults.standard.value(forKey: "price_shared") as? Int
    let spaceFacebook = UserDefaults.standard.value(forKey: "facebook") as? String ?? "no value"
    let spaceWhatsApp = UserDefaults.standard.value(forKey: "whatsapp") as? Int
    let spaceContact = UserDefaults.standard.value(forKey: "contact_number") as? Int


    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureDelegate()
        assignOutlets()
        assignGestureRecognizer()
        switchImageMethod()
     
    }
    
    @IBAction private func backButtonPressed( _ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DetailsViewController {
    
    func interactivePopGestureDelegate() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func assignOutlets() {
        
            spaceNameLabel.text = spaceName
            spaceAddressLabel.text = ("\(spaceDistrict ?? "no value") \(spaceStreet ?? "no value")")
            aboutSpaceLabel.text = aboutSpace
            pricePadgeLabel.text = String(spacePriceDay ?? 0)
            priceDayLabel.text = String(spacePriceDay ?? 0)
            priceMeetingLabel.text = String(spacePriceMeeting ?? 0)
            priceSmallLabel.text = String(spacePriceSmall ?? 0)
            priceGamesLabel.text = String(spacePriceGames ?? 0)
            priceSharedLabel.text = String(spacePriceShared ?? 0)
    }
}


//MARK:- Contacts Gesture Recognizer Methods:

extension DetailsViewController {
    
    func assignGestureRecognizer() {
        
        let gestureFacebook = UITapGestureRecognizer(target: self, action: #selector(facebookLink))
        facebookImage.addGestureRecognizer(gestureFacebook)
        facebookImage.isUserInteractionEnabled = true
        
        let gestureContact = UITapGestureRecognizer(target: self, action: #selector(ConatctNumber))
        contactImage.addGestureRecognizer(gestureContact)
        contactImage.isUserInteractionEnabled = true
        
        let gestureWhatsApp = UITapGestureRecognizer(target: self, action: #selector(WhatsAppNumber))
        whatsappImage.addGestureRecognizer(gestureWhatsApp)
        whatsappImage.isUserInteractionEnabled = true
    }
    
    @objc func facebookLink() {
        if let url = URL(string: spaceFacebook) {
            
            UIApplication.shared.open(url)
        }
    }
    
    @objc func ConatctNumber() {
        
        if let phoneCallURL = URL(string: "tel://\(spaceContact ?? 000)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func WhatsAppNumber() {
        
        if let whatsAppURL = URL(string: "tel://\(spaceWhatsApp ?? 000)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(whatsAppURL)) {
                application.open(whatsAppURL, options: [:], completionHandler: nil)
            }
        }
    }
    
}

//MARK:- Swich image Methods:

extension DetailsViewController {
    func switchImageMethod() {
        
        switch  UserDefaults.standard.bool(forKey: "free_wifi") {
        case true:
            wifiImage.image = UIImage(systemName: "wifi")
        case false:
            wifiImage.image = UIImage(systemName: "xmark.seal.fill")
        }
        
        switch  UserDefaults.standard.bool(forKey: "books_library") {
        case true:
            bookImage.image = UIImage(systemName: "book")
        case false:
            bookImage.image = UIImage(systemName: "xmark.seal.fill")
        }
        
        switch  UserDefaults.standard.bool(forKey: "coffee") {
        case true:
            coffeeImage.image = UIImage(named: "Coffee")
        case false:
            coffeeImage.image = UIImage(systemName: "xmark.seal.fill")
        }
        
        switch  UserDefaults.standard.bool(forKey: "meeting_room") {
        case true:
            meetingImage.image = UIImage(named: "meeting")
        case false:
            meetingImage.image = UIImage(systemName: "xmark.seal.fill")
        }
        
        switch  UserDefaults.standard.bool(forKey: "gamingRoom") {
        case true:
            gamesImage.image = UIImage(systemName: "gamecontroller")
        case false:
            gamesImage.image = UIImage(systemName: "xmark.seal.fill")
            

        }

    }
}
