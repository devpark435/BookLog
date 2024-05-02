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
    
    let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "책 제목, 저자, 출판사를 검색하세요"
        $0.obscuresBackgroundDuringPresentation = true
    }
    
    let searchListTableView = UITableView()
    
    var pageAble: Meta?
    var searchBookResult: [Book] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeStatusBarBgColor(bgColor: UIColor.white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        searchController.searchResultsUpdater = self
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        searchListTableView.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.identifier)
        setupNavigation()
        setupLayout()
    }
    
    func setupNavigation(){
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.searchController = searchController
    }
    
    func setupLayout(){
        view.addSubview(searchListTableView)
        searchListTableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
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
                self.searchBookResult = value.documents
                DispatchQueue.main.async {
                    self.searchListTableView.reloadData()
                }
                print(self.searchBookResult.count)
            case .failure(let error):
                print(error)
            }
        }
        print("searching...\(searchText)")
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBookResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.identifier) as? SearchListCell else {
            print("Search Cell Load Error")
            return UITableViewCell()
        }
        
        cell.configureCell(book: searchBookResult[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select Row Data \(searchBookResult[indexPath.row])")
    }
}

