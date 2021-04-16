
import UIKit
import JGProgressHUD
import Cosmos
import ExpandableLabel

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

    let spinner = JGProgressHUD()
    var space: SpaceInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.show(in: view)
        aboutSpaceLabel.numberOfLines = 2
        interactivePopGestureDelegate()
        assignOutlets()
        assignGestureRecognizer()
        switchImageMethod()
    }
    
    @IBAction private func backButtonPressed( _ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
    
        UserDefaults.standard.setValue(rating, forKey: "rating")
        
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
        
        spaceNameLabel.text = space?.name
        spaceAddressLabel.text = space?.spaceDistrict
        aboutSpaceLabel.text = space?.aboutSpace
        pricePadgeLabel.text = space?.pricePerDay
        priceDayLabel.text = space?.pricePerDay
        priceMeetingLabel.text = space?.pricePerDayMeetingRoom
        priceSmallLabel.text = space?.pricePerDaySmallRoom
        priceGamesLabel.text = space?.pricePerDayGamesRoom
        priceSharedLabel.text = space?.pricePerDaySharedSpace
        
        self.spinner.dismiss()
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
        if let url = URL(string: space!.facebookLink) {

            UIApplication.shared.open(url)
        }
    }

    @objc func ConatctNumber() {

        if let phoneCallURL = URL(string: "tel://\(space!.contactNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }

    @objc func WhatsAppNumber() {

        if let whatsAppURL = URL(string: "tel://\(space!.whatsAppNumber)") {
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
        
        if space?.freeWiFi == true {
            wifiImage.image = UIImage(systemName: "wifi")
        } else {wifiImage.image = UIImage(systemName: "xmark.seal.fill")}
        
        
        if space?.bookLibrary == true {
            bookImage.image = UIImage(systemName: "book")
        } else {bookImage.image = UIImage(systemName: "xmark.seal.fill")}
        
        
        if space?.coffee == true {
            coffeeImage.image = UIImage(named: "Coffee")
        } else {coffeeImage.image = UIImage(systemName: "xmark.seal.fill")}
        
        
        if space?.meetingRoom == true {
            meetingImage.image = UIImage(named: "Meeting")
        } else {meetingImage.image = UIImage(systemName: "xmark.seal.fill")}
        
        
        if space?.gamingRoom == true {
            gamesImage.image = UIImage(systemName: "gamecontroller")
        } else {gamesImage.image = UIImage(systemName: "xmark.seal.fill")}

    }
}
