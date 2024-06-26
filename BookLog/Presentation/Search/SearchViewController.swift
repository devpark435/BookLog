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
    
    let searchDetailViewController = SearchDetailViewController()
    
    // MARK: - UI Components
    
    lazy var keywordViewController = KeywordViewController().then{
        $0.searchViewController = self
    }
    
    lazy var searchController = UISearchController(searchResultsController: keywordViewController).then {
        $0.searchBar.placeholder = "\(selectedFilterOption)을(를) 검색하세요"
        $0.obscuresBackgroundDuringPresentation = true
    }
    
    let searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.backgroundColor = .white
        $0.register(SearchListCell.self, forCellWithReuseIdentifier: SearchListCell.identifier)
    }
    
    let viewHistoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.register(ViewHistoryCell.self, forCellWithReuseIdentifier: ViewHistoryCell.identifier)
    }
    
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
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        setupNavigation()
        setupCollectionView()
//        setupLayout()
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
    
    // MARK: - CollectionView
    
    func setupCollectionView() {
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        viewHistoryCollectionView.delegate = self
        viewHistoryCollectionView.dataSource = self
        
        searchResultCollectionView.collectionViewLayout = createSearchResultLayout()
        viewHistoryCollectionView.collectionViewLayout = createViewHistoryLayout()
    }
    
    // MARK: - Layout
    
    func setupLayout(){
        view.subviews.forEach { $0.removeFromSuperview() }
        
        view.addSubview(searchResultCollectionView)
        
        // UserDefaults에서 저장된 검색 결과 확인
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "SearchResults"),
           let savedSearchResults = try? JSONDecoder().decode([Book].self, from: savedData),
           !savedSearchResults.isEmpty {
            // 저장된 검색 결과가 있는 경우 컬렉션 뷰 표시
            view.addSubview(viewHistoryCollectionView)
            
            viewHistoryCollectionView.snp.makeConstraints{
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
                $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
                $0.height.equalTo(50)
            }
            
            searchResultCollectionView.snp.makeConstraints {
                $0.top.equalTo(viewHistoryCollectionView.snp.bottom).offset(10)
                $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        } else {
            // 저장된 검색 결과가 없는 경우 searchResultCollectionView만 설정
            searchResultCollectionView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
    
    // MARK: - Fetch Data
    
    func fetchSearchData(){
        BookAPIManager.shared.searchBookData(esearchText: self.searchText, page: 1, searchOption: self.filterTarget) { result in
            switch result{
            case .success(let value):
                print("Get Search Book Data")
                self.pageAble = value.meta
                self.searchBookResult = value.documents
                DispatchQueue.main.async {
                    self.searchResultCollectionView.reloadData()
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

// MARK: - CollectionView Delegate, DataSource, Layout

extension SearchViewController {
    func createSearchResultLayout() -> UICollectionViewCompositionalLayout {
        // searchResultCollectionView의 CompositionalLayout 생성
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            // searchResultCollectionView의 레이아웃 구성
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
        }
        return layout
    }
    
    func createViewHistoryLayout() -> UICollectionViewCompositionalLayout {
        // viewHistoryCollectionView의 CompositionalLayout 생성
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            // viewHistoryCollectionView의 레이아웃 구성
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(5), top: .fixed(0), trailing: .fixed(5), bottom: .fixed(0))
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
            
            return section
        }
        return layout
    }
}
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case viewHistoryCollectionView:
            // 저장된 검색 결과 개수 반환
            let defaults = UserDefaults.standard
            if let savedData = defaults.data(forKey: "SearchResults"),
               let savedSearchResults = try? JSONDecoder().decode([Book].self, from: savedData) {
                print("savedSearchResults.count : \(savedSearchResults.count)")
                return savedSearchResults.count
            } else {
                print("저장된 검색 결과가 없습니다.")
                return 0
            }
        case searchResultCollectionView:
            return searchBookResult.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case viewHistoryCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewHistoryCell.identifier, for: indexPath) as? ViewHistoryCell else {
                return UICollectionViewCell()
            }
            let defaults = UserDefaults.standard
            if let savedData = defaults.data(forKey: "SearchResults"),
               let savedSearchResults = try? JSONDecoder().decode([Book].self, from: savedData) {
                let book = savedSearchResults[indexPath.item]
                cell.configure(with: book.title)
            }
            return cell
        case searchResultCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchListCell.identifier, for: indexPath) as? SearchListCell else {
                return UICollectionViewCell()
            }
            let book = searchBookResult[indexPath.item]
            cell.configureCell(book: book)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case viewHistoryCollectionView:
            // 검색어 칩 선택 시
            let defaults = UserDefaults.standard
            if let savedData = defaults.data(forKey: "SearchResults"),
               let savedSearchResults = try? JSONDecoder().decode([Book].self, from: savedData) {
                if indexPath.item < savedSearchResults.count {
                    let selectedBook = savedSearchResults[indexPath.item]
                    let detailVC = SearchDetailViewController()
                    detailVC.book = selectedBook
                    detailVC.delegate = self
                    present(detailVC, animated: true)
                }
            }
        case searchResultCollectionView:
            let selectedBook = searchBookResult[indexPath.item]
            // 최근 본 책 추가
            saveSearchResult(selectedBook)
            // 최근 본 책 목록 갱신
            viewHistoryCollectionView.reloadData()
            setupLayout()
            
            let detailVC = SearchDetailViewController()
            detailVC.book = selectedBook
            detailVC.delegate = self
            
            present(detailVC, animated: true)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case viewHistoryCollectionView:
            return
        case searchResultCollectionView:
            if indexPath.item == searchBookResult.count - 1 {
                guard let pageAble = self.pageAble else { return }
                if pageAble.isEnd {
                    print("End of Search")
                    return
                }
                
                self.page += 1
                BookAPIManager.shared.searchBookData(esearchText: self.searchText, page: self.page, searchOption: self.filterTarget) { result in
                    switch result {
                    case .success(let value):
                        self.pageAble = value.meta
                        self.searchBookResult += value.documents
                        print("Get More Search Book Data")
                        DispatchQueue.main.async {
                            self.searchResultCollectionView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        default:
            return
        }
    }
}

extension SearchViewController {
    func saveSearchResult(_ book: Book) {
        let defaults = UserDefaults.standard
        
        // UserDefaults에서 기존 검색 결과 가져오기
        var searchResults = defaults.data(forKey: "SearchResults").flatMap { try? JSONDecoder().decode([Book].self, from: $0) } ?? []
        
        // 중복 검사
        if !searchResults.contains(where: { $0.title == book.title }) {
            // 중복되지 않은 경우에만 새로운 검색 결과 추가
            searchResults.append(book)
            
            // 최대 10개까지 유지하기 위해 오래된 항목 제거
            if searchResults.count > 10 {
                searchResults.removeFirst(searchResults.count - 10)
            }
            
            // 업데이트된 검색 결과를 UserDefaults에 저장
            if let data = try? JSONEncoder().encode(searchResults) {
                defaults.set(data, forKey: "SearchResults")
                printSavedSearchResults()
            }
        }
    }
    
    func printSavedSearchResults() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "SearchResults"),
           let savedSearchResults = try? JSONDecoder().decode([Book].self, from: data) {
            print("Saved Search Results:")
            for result in savedSearchResults {
                print(result)
            }
        } else {
            print("No saved search results found.")
        }
    }
}

extension SearchViewController: SearchDetailViewControllerDelegate {
    func searchDetailViewControllerDidDismiss(_ viewController: SearchDetailViewController) {
        showBookAlert(for: viewController.book)
    }
    
    func showBookAlert(for book: Book?) {
        guard let book = book else { return }
        
        let alertTitle = "책을 담았습니다!"
        let alertMessage = "\(book.title) 책이 성공적으로 담겼습니다."
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
