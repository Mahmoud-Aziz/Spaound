//
//  DashboardFindViewController.swift
//  Spaound
//
//  Created by Mahmoud Aziz on 05/03/2021.
//

import UIKit
import Firebase


class DashboardFindViewController: UIViewController {

    @IBOutlet private weak var dashboardFindTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var spacesSearchResult = [String]()
    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashboardFindTableView.delegate = self
        dashboardFindTableView.dataSource = self
        searchBar.delegate = self
        
        let customCell = UINib(nibName: "CustomCellDashboardTableView", bundle: nil)
        dashboardFindTableView.register(customCell, forCellReuseIdentifier: "CustomCellDashboardTableView")
        
    

    }
}


extension DashboardFindViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return spacesSearchResult.count
        } else {
            return 5
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellDashboardTableView") as! CustomCellDashboardTableView
        if searching {
            cell.textLabel?.text = spacesSearchResult[indexPath.row]
        } else {
            cell.textLabel?.text = "no data"
        }
        return cell
    }
   
}

extension DashboardFindViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        

        Firebase.Database.database().reference().queryEqual(toValue: searchText)
        
        SpacesDatabaseManager.shared.retrieveSpace(with: searchText, completion:{ [weak self] space in
            self?.spacesSearchResult.append(space.spaceName)
            self?.searching = true
            self?.dashboardFindTableView.reloadData()
        })
    }
    
    
    
}
