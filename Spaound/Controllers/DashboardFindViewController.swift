

import UIKit
import JGProgressHUD


class DashboardFindViewController: UIViewController {
    
    @IBOutlet private weak var dashboardFindTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var spaces = [[String:Any]]()
    private var results = [[String:Any]]()
    private var hasFetched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashboardFindTableView.delegate = self
        dashboardFindTableView.dataSource = self
        dashboardFindTableView.isHidden = true
        searchBar.delegate = self
        
        let customCell = UINib(nibName: "CustomCellDashboardTableView", bundle: nil)
        dashboardFindTableView.register(customCell, forCellReuseIdentifier: "CustomCellDashboardTableView")
        
    }
}

//MARK:- Table View delegate and datasource methods

extension DashboardFindViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellDashboardTableView", for: indexPath) as! CustomCellDashboardTableView
        
        cell.textLabel?.text = results[indexPath.row]["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        let vc = DetailsViewController()
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- Search Bar methods 

extension DashboardFindViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        results.removeAll()
        spinner.show(in:view)
        searchBar.resignFirstResponder()

        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String) {
        //check if array has firebase results
        if hasFetched {
            //if yes: filter
            filterSpaces(with: query)
            
        } else {
            //if not, fetch then filter
            SpacesDatabaseManager.shared.getAllSpaces(completion: { [weak self] result in
                switch result {
                case.success(let spacesCollection):
                    self?.hasFetched = true
                    self?.spaces = spacesCollection
                    self?.filterSpaces(with: query)
                case.failure(let error):
                    print("Failed to get spaces: \(error)")
                }
            })
        }
    }
    
    func filterSpaces(with term: String) {
        //update the UI: either show results or show no results label
        guard hasFetched else {
            return
        }
        
        self.spinner.dismiss()
        
        let results: [[String:Any]] = self.spaces.filter({
            guard let name = $0["name"] else {
                return false
            }
            return (name as AnyObject).hasPrefix(term.lowercased())
        })
        
        self.results = results
        print(self.results)
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            self.dashboardFindTableView.isHidden = true
        }
        else {
            self.dashboardFindTableView.isHidden = false
            self.dashboardFindTableView.reloadData()
            
        }
    }
    
}




