

import UIKit
import FirebaseDatabase


class RecommendedSpacesDataSource: NSObject, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCellCollectionView", for: indexPath) as! CustomCellCollectionView
        
        

        return cell
    }
    
    
    
    

}






