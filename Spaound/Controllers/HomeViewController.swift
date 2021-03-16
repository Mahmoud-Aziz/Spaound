

import UIKit
import FirebaseAuth


class HomeViewController: UIViewController {
    
    
    @IBOutlet private weak var recommendedSpacesCollectionView: UICollectionView!
    @IBOutlet private weak var popularSpacesTableView:UITableView!
    @IBOutlet private weak var hiUserLabel:UILabel! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userName = "\(UserDefaults.standard.value(forKey: "first_name") as? String ?? "") \(UserDefaults.standard.value(forKey: "last_name")as? String ?? "")"
        
        hiUserLabel.text = userName
        
        spacesDatabaseInsert.shared.insertSpaces()
        
        recommendedSpacesCollectionView.dataSource = self
        popularSpacesTableView.dataSource = self
        
        let customCell = UINib(nibName: "CustomCellCollectionView", bundle: nil)
        recommendedSpacesCollectionView.register(customCell, forCellWithReuseIdentifier: "CustomCellCollectionView")

        let tableViewCustomCell = UINib(nibName: "CustomCellTableView", bundle: nil)
        popularSpacesTableView.register(tableViewCustomCell, forCellReuseIdentifier: "CustomCellTableView")

        validateAuth()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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

//MARK:- Collection View Data Source and Delegate Methods:

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellTableView", for: indexPath) as! CustomCellTableView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Table View Data Source and Delegate Methods:

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCellCollectionView", for: indexPath) as! CustomCellCollectionView
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = DetailsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
