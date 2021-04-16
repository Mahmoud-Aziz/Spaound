
import UIKit
import FirebaseAuth

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let homeTab = HomeViewController()
        let findTab = DashboardFindViewController()
        let settingsTab = SettingsViewController()
        
        navigationController?.setNavigationBarHidden(true, animated: animated)

        let tabBar = UITabBarController(nibName: "UITabBarController", bundle: nil)
        tabBar.modalPresentationStyle = .fullScreen
        
        let homeTabItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.circle"), selectedImage: UIImage(systemName: "house.circle.fill"))
        homeTab.tabBarItem = homeTabItem
        
        let findTabItem = UITabBarItem(title: "Find", image: UIImage(systemName: "location.circle"), selectedImage: UIImage(systemName: "location.circle.fill"))
        findTab.tabBarItem = findTabItem
        
        let settingsTabItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        settingsTab.tabBarItem = settingsTabItem
        
        self.viewControllers = [homeTab,findTab,settingsTab]
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
   
    }

