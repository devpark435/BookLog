//
//  BottomTabBarController.swift
//  BookLog
//
//  Created by 박현렬 on 5/1/24.
//

import UIKit

class BottomTabBarController: UITabBarController{
    
    let searchVC = SearchViewController()
    let BLogVC = BookLogViewController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controllers = [searchVC, BLogVC]
        self.viewControllers = controllers.map{UINavigationController(rootViewController: $0)}
        
        setTabBar()
    }
    
    // 탭 바 설정
    func setTabBar(){
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        BLogVC.tabBarItem = UITabBarItem(title: "BLog", image: UIImage(systemName: "person"), tag: 1)
        // 탭 바 배경색 설정
        UITabBar.appearance().backgroundColor = UIColor.white
        
        // 탭 바 아이템 색상 설정
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        UITabBar.appearance().tintColor = UIColor.black
        
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
        
        // 탭 바 아이템 텍스트를 bold로 설정
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
    }
    
}
