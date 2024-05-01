//
//  SearchViewController.swift
//  BookLog
//
//  Created by 박현렬 on 5/1/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class SearchViewController: UIViewController{
    
    let searchController = UISearchController().then {
        $0.searchBar.placeholder = "책 제목, 저자, 출판사를 검색하세요"
        $0.obscuresBackgroundDuringPresentation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeStatusBarBgColor(bgColor: UIColor.white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.searchController = searchController
    }
    
    func changeStatusBarBgColor(bgColor: UIColor?) {
        if #available(iOS 13.0, *) {
            if #available(iOS 15.0, *) {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                let statusBarManager = window?.windowScene?.statusBarManager
                let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
                statusBarView.backgroundColor = bgColor
                window?.addSubview(statusBarView)
            } else {
                let window = UIApplication.shared.windows.first
                let statusBarManager = window?.windowScene?.statusBarManager
                let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
                statusBarView.backgroundColor = bgColor
                window?.addSubview(statusBarView)
            }
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = bgColor
        }
    }
    
}
