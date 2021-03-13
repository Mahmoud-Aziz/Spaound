

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var userNameLabel:UILabel! 
    @IBOutlet weak var signOutButton:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        signOutButton.layer.cornerRadius = 16.0
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        
        
//        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
//              switch user {
//              case .none:
//                  print("USER NOT FOUND IN CHECK AUTH STATE")
//              case .some(let user):
//                  print("USER FOUND WITH ID: \(user.uid)")
//                print("display name \(user.displayName)")
//                self?.userNameLabel.text = user.displayName
//
//              }
//          }
      
            let user = Auth.auth().currentUser
            if let user = user {
                let userName = user.displayName
                self.userNameLabel.text = userName
            }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfileImage))
        
        profileImageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapChangeProfileImage() {
        presentPhotoActionSheet()
        
    }
    
    @IBAction private func signOutButtonPressed(_ sender:UIButton) {
        
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {
            [weak self] _ in
            
            //logout facebook
            FBSDKLoginKit.LoginManager().logOut()
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = EntryAuthenticationViewController()
                
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }
            catch {
                print("Failed to log out")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet,animated: true)
        
    }
}



extension SettingsViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self] _ in
            self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        print("presented")
        present(actionSheet, animated: true)
        
    }
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    func presentPhotoPicker() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        picker.dismiss(animated: true, completion: nil)
//        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
//            return
//        }
//        self.profileImageView.image = selectedImage
//        
//        let fileName = SpaoundUser
//        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: {
//            result in
//            switch result {
//            case .success(let downloadUrl):
//                UserDefaults.standard.set(downloadUrl, forKey: "pofile_picture_url")
//                print(downloadUrl)
//            case .failure(let error):
//                print("Storage manager error: \(error)")
//            }
//        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
