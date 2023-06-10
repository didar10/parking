//
//  TabBarViewController.swift
//  Parking
//
//  Created by Erzhan Taipov on 06.06.2023.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        
        let homeVC = HomeVC()
        let homeNav = UINavigationController(rootViewController: homeVC)
        
        let historyVC = ParkingHistoryVC()
        let historyNav = UINavigationController(rootViewController: historyVC)
        
        let profileVC = ProfileVC()
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        viewControllers = [homeNav, historyNav, profileNav]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Customize the tab bar items
        guard let items = tabBar.items else { return }
        items[0].title = "Бронирование"
        items[0].image = UIImage(named: "NewHome")?.withRenderingMode(.alwaysTemplate)
        items[1].title = "Мои парковки"
        items[1].image = UIImage(named: "newRecordsSelected")?.withRenderingMode(.alwaysTemplate)
        items[2].title = "Личный кабинет"
        items[2].image = UIImage(named: "newProfileSelected")?.withRenderingMode(.alwaysTemplate)
        
    }
    
    
    func configureTabBar() {
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.tintColor = .systemBlue
        tabBar.barTintColor = .white
        delegate = self
    }
    
    

    
}
extension TabBarViewController: UITabBarControllerDelegate {
    
}
