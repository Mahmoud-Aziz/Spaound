

import UIKit
import FirebaseDatabase


class RecommendedSpacesDataSource: NSObject, UICollectionViewDataSource {
    
    var spaces:[Space] = []
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCellCollectionView", for: indexPath) as! CustomCellCollectionView
        
        DatabaseManager.shared.insertSpaceInfo(with: SpaceInfo(spaceName: "spaceOne", pricePerDay: 10), completion: {exists in
            if exists {
                return
            }
            
        })

        DatabaseManager.shared.insertSpaceInfo(with: SpaceInfo(spaceName: "spaceTwo", pricePerDay: 10), completion: {exists in
            if exists {
                return
            }
            
        })
        
        DatabaseManager.shared.insertSpaceInfo(with: SpaceInfo(spaceName: "spaceThree", pricePerDay: 10), completion: {exists in
            if exists {
                return
            }
            
        })
        cell.backgroundColor = .blue
        return cell
    }
    
    

}

 struct Space {
    
  var name = ""
  var price = 0
    
}





