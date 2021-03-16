
import UIKit

class PopularSpacesViewController: UIViewController {

    @IBOutlet private weak var spacesTableView:UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let customCell = UINib(nibName: "TableViewCustomCell", bundle: nil)
        spacesTableView.register(customCell, forCellReuseIdentifier: "TableViewCustomCell")
    }
    
    @IBAction private func backButtonPressed( _ sender:UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

}

extension PopularSpacesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCustomCell", for: indexPath)
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
