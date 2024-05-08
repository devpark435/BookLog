//
//  BookLogViewController.swift
//  BookLog
//
//  Created by 박현렬 on 5/1/24.
//

import UIKit
import Then
import SnapKit

class BookLogViewController: UIViewController{
    
    var menu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    var menuItems: [UIAction]{
        return[
            UIAction(title: "추가", image: UIImage(systemName: "bookmark.fill"), handler: { _ in
                print("추가메뉴 클릭")
            }),
            UIAction(title: "전체 삭제", image: UIImage(systemName: "trash.fill"),attributes: .destructive , handler: { _ in
                print("전체 삭제")
            })
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        BookDataManager.shared.fetchBooks()
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationItem.title = "BookLog"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let menuButton = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)
        menuButton.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = menuButton
        navigationController?.navigationBar.backgroundColor = .white
    }
    
}
