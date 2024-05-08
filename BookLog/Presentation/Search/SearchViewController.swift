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
    
    // MARK: - UI Components
    
    lazy var keywordViewController = KeywordViewController().then{
        $0.searchViewController = self
    }
    
    lazy var searchController = UISearchController(searchResultsController: keywordViewController).then {
        $0.searchBar.placeholder = "\(selectedFilterOption)을(를) 검색하세요"
        $0.obscuresBackgroundDuringPresentation = true
    }
    
    let searchListTableView = UITableView()
    
    var page: Int = 1
    var searchText: String = ""
    
    var pageAble: Meta?
    var searchBookResult: [Book] = []
    var keyword: [String] = []
    
    let filterOptions = ["제목", "저자", "출판사"]
    var selectedFilterOption = "제목" {
        didSet {
            updateSearchBarPlaceholder()
        }
    }
    var filterTarget = "title"
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeStatusBarBgColor(bgColor: UIColor.white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        searchListTableView.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.identifier)
        setupNavigation()
        setupLayout()
        setupFilterButton()
    }
    
    // MARK: - SearchFilter
    
    func setupFilterButton() {
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(showFilterOptions))
        filterButton.tintColor = .darkGray
        navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc func showFilterOptions() {
        let alertController = UIAlertController(title: "검색 필터", message: nil, preferredStyle: .actionSheet)
        
        for option in filterOptions {
            let action = UIAlertAction(title: option, style: .default) { [weak self] _ in
                self?.selectedFilterOption = option
                self?.performSearch()
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func performSearch() {
        switch selectedFilterOption {
        case "제목":
            filterTarget = "title"
            print(self.filterTarget)
        case "저자":
            filterTarget = "person"
            print(self.filterTarget)
        case "출판사":
            filterTarget = "publisher"
            print(self.filterTarget)
        default:
            break
        }
    }
    
    func updateSearchBarPlaceholder() {
        searchController.searchBar.placeholder = "\(selectedFilterOption)을(를) 검색하세요"
    }
    
    // MARK: - Navigation
    
    func setupNavigation(){
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.searchController = searchController
    }
    
    // MARK: - Layout
    
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
    
    // MARK: - Fetch Data
    
    func fetchSearchData(){
        BookAPIManager.shared.searchBookData(esearchText: self.searchText, page: 1, searchOption: self.filterTarget) { result in
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
}

// MARK: - keyword Search

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.searchText = searchText
        print("Get Search Text : \(self.searchText)")
        fetchSearchData()
    }
}

extension SearchViewController {
    func refetchSearchData() {
        searchController.searchBar.text = searchText
        fetchSearchData()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if let viewController = searchController.searchResultsController as? KeywordViewController {
            viewController.updateSuggestedSearchTerms(with: searchText, searchOption: self.filterTarget)
        }
    }
}

extension KeywordViewController {
    func updateSuggestedSearchTerms(with searchText: String, searchOption: String) {
        // 검색어를 기반으로 추천 검색어 데이터 업데이트
        BookAPIManager.shared.searchKeywordData(esearchText: searchText, searchOption: searchOption) { result in
            switch result {
            case .success(let value):
                if searchOption == "title" {
                    self.keywordSearchItems = value.documents
                        .map({ $0.title })
                } else if searchOption == "person" {
                    self.keywordSearchItems = value.documents
                        .map({ $0.authors.joined(separator: ", ") })
                } else {
                    self.keywordSearchItems = value.documents
                        .map({ $0.publisher })
                }
                
                DispatchQueue.main.async {
                    self.keywordTableView.reloadData()
                }
                
            case .failure(let error):
                print("실시간 검색어 추천 에러 \(error)")
            }
        }
    }
}

// // MARK: - TableView Delegate, DataSource

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
        let detailVC = SearchDetailViewController()
        detailVC.book = searchBookResult[indexPath.row]
        present(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row == searchBookResult.count - 1{
            guard let pageAble = self.pageAble else { return }
            if pageAble.isEnd{
                print("End of Search")
                return
            }
            self.page += 1
            BookAPIManager.shared.searchBookData(esearchText: self.searchText, page: self.page, searchOption: self.filterTarget) { result in
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

