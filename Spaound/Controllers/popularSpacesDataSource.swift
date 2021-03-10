
import UIKit

class PopularSpacesDataSource: NSObject, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 5 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellTableView", for: indexPath) as! CustomCellTableView
        return cell
    }
    
    
    
    
    
    
    
}
