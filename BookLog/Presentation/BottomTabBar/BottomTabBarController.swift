//
//  BottomTabBarController.swift
//  BookLog
//
//  Created by 박현렬 on 5/1/24.
//

import UIKit

class BottomTabBarController: UITabBarController{
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchVC = SearchViewController()
        let BLogVC = BookLogViewController()
        
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        BLogVC.tabBarItem = UITabBarItem(title: "BLog", image: UIImage(systemName: "person"), tag: 1)
        
        let controllers = [searchVC, BLogVC]
        self.viewControllers = controllers.map{UINavigationController(rootViewController: $0)}
        
        // 탭 바 배경색 설정
        UITabBar.appearance().backgroundColor = UIColor.white
        
        // 탭 바 아이템 색상 설정
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        UITabBar.appearance().tintColor = UIColor.black
        
        // 탭 바 아이템 텍스트를 bold로 설정
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
    }
    
}
