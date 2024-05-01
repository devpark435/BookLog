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
    
    var pageAble: Meta?
    var searchBookModel: [Book] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeStatusBarBgColor(bgColor: UIColor.white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        searchController.searchResultsUpdater = self
        setupNavigation()
    }
    
    func setupNavigation(){
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
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

extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        BookAPIManager.shared.searchBookData(esearchText: searchText) { result in
            switch result{
            case .success(let value):
                print("Get Search Book Data")
                self.pageAble = value.meta
                self.searchBookModel = value.documents
                print(self.searchBookModel.count)
            case .failure(let error):
                print(error)
            }
        }
        print("searching...\(searchText)")
    }
}

