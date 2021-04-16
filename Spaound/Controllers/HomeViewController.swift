

import UIKit
import FirebaseAuth
import JGProgressHUD
import Cosmos

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var recommendedSpacesCollectionView: UICollectionView!
    @IBOutlet private weak var popularSpacesTableView:UITableView!
    @IBOutlet private weak var hiUserLabel:UILabel!

    let spinner = JGProgressHUD()
    var spaces: [SpaceInfo] = []
    
    private static var rowsCount = 100
    private var ratingStorage = [Double](repeating: 0, count: rowsCount)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAuth()
        self.navigationItem.title = "title"

        for i in 0..<HomeViewController.rowsCount {
          ratingStorage[i] = Double(i) / 99 * 5
        }
        
        recommendedSpacesCollectionView.dataSource = self
        popularSpacesTableView.dataSource = self
        spinner.show(in: view)
        
        SpacesDatabaseManager.shared.retrieveSpaces { [weak self] (result) in
            switch result {
            case .success(let spaces):
                self?.spinner.dismiss()
                self?.spaces = spaces
            case .failure(let error):
                print("error fetching data: \(error)")
            }
            self?.popularSpacesTableView.reloadData()
            self?.recommendedSpacesCollectionView.reloadData()
        }
        assignHiUserLabel()
        registerCells()
        validateAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    private func registerCells() {
        let customCell = UINib(nibName: "CustomCellCollectionView", bundle: nil)
        recommendedSpacesCollectionView.register(customCell, forCellWithReuseIdentifier: "CustomCellCollectionView")

        let tableViewCustomCell = UINib(nibName: "CustomCellTableView", bundle: nil)
        popularSpacesTableView.register(tableViewCustomCell, forCellReuseIdentifier: "CustomCellTableView")
    }
    
    private func assignHiUserLabel() {
        let userName = "\(UserDefaults.standard.value(forKey: "first_name") as? String ?? "") \(UserDefaults.standard.value(forKey: "last_name")as? String ?? "")"
        hiUserLabel.text = userName
    }
}

//MARK:- Table View Data Source and Delegate Methods:

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return spaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellTableView", for: indexPath) as! CustomCellTableView
       
        let rating = ratingStorage[indexPath.row]
        
        cell.update(rating)
        
        cell.cosmosView.didTouchCosmos = {[weak self] rating in
            self?.popularSpacesTableView.allowsSelection = false
        }

        cell.cosmosView.didFinishTouchingCosmos = { [weak self] rating in
          self?.ratingStorage[indexPath.row] = rating
            cell.update(rating)
            self?.popularSpacesTableView.allowsSelection = true
        }

        cell.configureCell(space: spaces[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailsViewController()
        vc.space = self.spaces[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Collection View Data Source and Delegate Methods:

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return spaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCellCollectionView", for: indexPath) as! CustomCellCollectionView
        
        cell.configureCell(space: spaces[indexPath.row])
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = DetailsViewController()
        vc.space = self.spaces[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
}
