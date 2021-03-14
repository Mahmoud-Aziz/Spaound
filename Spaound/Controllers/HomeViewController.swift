

import UIKit
import FirebaseAuth


class HomeViewController: UIViewController {
    
    
    @IBOutlet private weak var recommendedSpacesCollectionView: UICollectionView!
    @IBOutlet private weak var popularSpacesTableView:UITableView!
    @IBOutlet private weak var hiUserLabel:UILabel! 
    
    private let recommendedDataSource = RecommendedSpacesDataSource()
    private let popularSpacesDataSource = PopularSpacesDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userName = "\(UserDefaults.standard.value(forKey: "first_name") as? String ?? "") \(UserDefaults.standard.value(forKey: "last_name")as? String ?? "")"
        
        hiUserLabel.text = userName
        
        spacesDatabaseInsert.shared.insertSpaces()
        
        recommendedSpacesCollectionView.dataSource = recommendedDataSource
        popularSpacesTableView.dataSource = popularSpacesDataSource
        
        let customCell = UINib(nibName: "CustomCellCollectionView", bundle: nil)
        recommendedSpacesCollectionView.register(customCell, forCellWithReuseIdentifier: "CustomCellCollectionView")

        let tableViewCustomCell = UINib(nibName: "CustomCellTableView", bundle: nil)
        popularSpacesTableView.register(tableViewCustomCell, forCellReuseIdentifier: "CustomCellTableView")

        validateAuth()
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: true)

    }
    
    @IBAction private func seeAllButtonPressed(_ Sender:UIButton) {
        
        let vc = PopularSpacesViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = EntryAuthenticationViewController()
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
  
}


