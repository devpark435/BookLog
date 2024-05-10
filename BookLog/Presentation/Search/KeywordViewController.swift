//
//  KeywordViewController.swift
//  BookLog
//
//  Created by 박현렬 on 5/7/24.
//

import UIKit

class KeywordViewController: UIViewController{
    
    let keywordCellIdentifier = "KeywordCell"
    
    var keywordSearchItems: [String] = []
    
    let keywordTableView = UITableView()
    
    var searchViewController: SearchViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
        setupLayout()
    }
    
    private func setupTableView() {
        keywordTableView.dataSource = self
        keywordTableView.delegate = self
        keywordTableView.register(UITableViewCell.self, forCellReuseIdentifier: keywordCellIdentifier)
    }
    
    private func setupLayout() {
        view.addSubview(keywordTableView)
        keywordTableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension KeywordViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywordSearchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: keywordCellIdentifier, for: indexPath)
        cell.textLabel?.text = keywordSearchItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension KeywordViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedText = keywordSearchItems[indexPath.row]
        searchViewController?.searchText = selectedText
        searchViewController?.refetchSearchData()
        print("selectedText: \(selectedText) = \(searchViewController?.searchText)")
        
        // 검색 결과 화면으로 돌아가기
        searchViewController?.navigationController?.popViewController(animated: true)
    }
}
