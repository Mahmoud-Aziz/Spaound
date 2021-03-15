
import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var nextButton:UIButton!
  
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        slides = [
            OnboardingSlide(title: "You can find any place here", description: "Good mood good place, let's go!", image: UIImage(named: "Onboarding1")!),
            
            OnboardingSlide(title: "Find a place you can study", description: "It’ hard to find a quiet place to study Around allow you to see place reviews.", image: UIImage(named: "Onboarding2")!),
            
            OnboardingSlide(title: "Save money when book with us", description: "Save more money was never easy Around will make you a lot of offers.", image: UIImage(named: "Onboarding3")!)
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction private func nextButtonPressed(_sender:UIButton) {
        
        if currentPage == slides.count - 1 {
            let vc = EntryAuthenticationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
      
    }
  

}

//MARK:- CollectionView datasource and delegate methods

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingViewControllerCell.identifier, for: indexPath) as! OnboardingViewControllerCell
        
        cell.setup(slides[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }



}
