

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FirebaseStorage
import Kingfisher

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var userNameLabel:UILabel! 
    @IBOutlet weak var signOutButton:UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userName = "\(UserDefaults.standard.value(forKey: "first_name") as? String ?? "") \(UserDefaults.standard.value(forKey: "last_name")as? String ?? "")"
        
        let mobileNumber = UserDefaults.standard.value(forKey: "phone_number") as? Int
                            
        userNameLabel.text = userName
        mobileNumberLabel.text = String(mobileNumber ?? 0)
        
        let url = UserDefaults.standard.value(forKey: "profile_picture_url")
        let urll = URL(string: url as! String)
        profileImageView.kf.setImage(with: urll)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2 
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfileImage))
        
        profileImageView.addGestureRecognizer(gesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.profileImageView.image = selectedImage
        guard let image = profileImageView.image, let data = image.pngData() else {
            return
        }
        
        let email = UserDefaults.standard.value(forKey: "email") as? String
        var safeEmail = email?.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail?.replacingOccurrences(of: "@", with: "-")
        
        let fileName = "\(safeEmail ?? "")_profile_picture.png"
        
        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
            switch result {
            case .success(let downloadUrl):
                UserDefaults.standard.setValue(downloadUrl, forKey: "profile_picture_url")
                print(downloadUrl)
            case .failure(let error):
                print("storage manager error: \(error)")
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
