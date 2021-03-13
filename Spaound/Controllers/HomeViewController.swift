

import UIKit
import FirebaseAuth


class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var recommendedPlacesCollectionView: UICollectionView!
    @IBOutlet weak var popularSpacesTableView:UITableView!
    
    private let recommendedDataSource = RecommendedSpacesDataSource()
    private let popularSpacesDataSource = PopularSpacesDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        spacesDatabaseInsert.shared.insertSpaces()
        
        recommendedPlacesCollectionView.dataSource = recommendedDataSource
        popularSpacesTableView.dataSource = popularSpacesDataSource
        
        let customCell = UINib(nibName: "CustomCellCollectionView", bundle: nil)
        recommendedPlacesCollectionView.register(customCell, forCellWithReuseIdentifier: "CustomCellCollectionView")

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


