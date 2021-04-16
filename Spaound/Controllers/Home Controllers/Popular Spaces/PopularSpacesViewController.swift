
import UIKit
import JGProgressHUD

class PopularSpacesViewController: UIViewController {

    @IBOutlet private weak var spacesTableView:UITableView!
    var spaces: [SpaceInfo] = []
    let spinner = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.show(in: view)
        SpacesDatabaseManager.shared.retrieveSpaces { [weak self] (result) in
            
            switch result {
            case .success(let spaces):
                self?.spinner.dismiss()
                self?.spaces = spaces
            case .failure(let error):
                print("error fetching data: \(error)")
            }
            self?.spacesTableView.reloadData()
        }
        
        let customCell = UINib(nibName: "TableViewCustomCell", bundle: nil)
        spacesTableView.register(customCell, forCellReuseIdentifier: "TableViewCustomCell")
    }
    
    @IBAction private func backButtonPressed( _ sender:UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

}

extension PopularSpacesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCustomCell", for: indexPath) as! TableViewCustomCell
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
