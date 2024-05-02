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
    
    var page: Int = 1
    var searchText: String = ""
    
    var pageAble: Meta?
    var searchBookResult: [Book] = []
    var keyword: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeStatusBarBgColor(bgColor: UIColor.white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
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
    
    func fetchSearchData(){
        BookAPIManager.shared.searchBookData(esearchText: self.searchText, page: 1) { result in
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
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.searchText = searchText
        print("Get Search Text : \(self.searchText)")
        fetchSearchData()
    }
}
extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let esearchText = searchController.searchBar.text else { return }
        BookAPIManager.shared.searchBookData(esearchText: esearchText, page: 1) { result in
            switch result{
            case .success(let value):
                self.keyword = value.documents.filter({ $0.title.hasPrefix(esearchText) }).map({ $0.title })
                print(self.keyword)
            case .failure(let error):
                print(error)
            }
        }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row == searchBookResult.count - 1{
            guard let pageAble = self.pageAble else { return }
            if pageAble.isEnd{
                print("End of Search")
                return
            }
            self.page += 1
            BookAPIManager.shared.searchBookData(esearchText: self.searchText, page: self.page) { result in
                switch result{
                case .success(let value):
                    self.pageAble = value.meta
                    self.searchBookResult += value.documents
                    print("Get More Search Book Data")
                    DispatchQueue.main.async {
                        self.searchListTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

