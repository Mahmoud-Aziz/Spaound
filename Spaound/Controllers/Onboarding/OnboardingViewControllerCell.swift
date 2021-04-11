
import UIKit

class OnboardingViewControllerCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingViewControllerCell.self)
    
    @IBOutlet private weak var slidetitleLabel:UILabel!
    @IBOutlet private weak var slideDescriptionLabel:UILabel!
    @IBOutlet private weak var slideImageView:UIImageView!
    
    func setup(_ slide:OnboardingSlide) {
        slideImageView.image = slide.image
        slidetitleLabel.text = slide.title
        slideDescriptionLabel.text = slide.description
    }
}
