
import UIKit

class PopularSpacesViewController: UIViewController {

    @IBOutlet private weak var spacesTableView:UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let customCell = UINib(nibName: "TableViewCustomCell", bundle: nil)
        spacesTableView.register(customCell, forCellReuseIdentifier: "TableViewCustomCell")
    }

}

extension PopularSpacesViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCustomCell", for: indexPath)
        return cell 
    }
    
    
    
}
