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
        
        viewControllers = [HomeVC(), ParkingHistoryVC(), ProfileVC()]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Customize the tab bar items
        guard let items = tabBar.items else { return }
        items[0].title = "First"
        items[0].image = UIImage(named: "NewHome")?.withRenderingMode(.alwaysTemplate)
        items[1].title = "Second"
        items[1].image = UIImage(named: "newRecordsSelected")?.withRenderingMode(.alwaysTemplate)
        items[2].title = "Third"
        items[2].image = UIImage(named: "newProfileSelected")?.withRenderingMode(.alwaysTemplate)
        
    }
    
    
    func configureTabBar() {
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.tintColor = .systemGreen
        tabBar.barTintColor = .white
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.systemGreen.cgColor
        tabBar.layer.cornerRadius = 25
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        tabBar.layer.shadowColor = UIColor.systemGreen.cgColor
        tabBar.clipsToBounds = true
        tabBar.layer.masksToBounds = true
        delegate = self
    }
    
    

    
}
extension TabBarViewController: UITabBarControllerDelegate {
    
}
