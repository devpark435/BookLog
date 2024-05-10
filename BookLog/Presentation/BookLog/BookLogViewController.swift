//
//  BookLogViewController.swift
//  BookLog
//
//  Created by 박현렬 on 5/1/24.
//

import UIKit
import Then
import SnapKit

protocol BookLogViewControllerDelegate: AnyObject {
    func bookLogViewControllerDidTapAddButton(_ bookLogViewController: BookLogViewController)
}

class BookLogViewController: UIViewController{
    
    weak var delegate: BookLogViewControllerDelegate?
    
    var menu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    var menuItems: [UIAction]{
        return[
            UIAction(title: "추가", image: UIImage(systemName: "bookmark.fill"), handler: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.bookLogViewControllerDidTapAddButton(self)
            }),
            UIAction(title: "전체 삭제", image: UIImage(systemName: "trash.fill"),attributes: .destructive , handler: { _ in
                BookDataManager.shared.deleteAllBooks()
                DispatchQueue.main.async {
                    self.loadBooks()
                    self.reviewedBooksCollectionView.reloadData()
                    self.allBooksCollectionView.reloadData()
                }
                print("전체 삭제")
            })
        ]
    }
    
    var reviewedBooks: [BookEntityModel] = []
    var allBooks: [BookEntityModel] = []
    
    var reviewedBooksCollectionView: UICollectionView!
    var allBooksCollectionView: UICollectionView!
    
    let allBooksLabel = UILabel().then {
        $0.text = "모든 책"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    let reviewedBooksLabel = UILabel().then {
        $0.text = "리뷰된 책"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        loadBooks()
        setupNavigation()
        setupCollectionViews()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBooks()
        reviewedBooksCollectionView.reloadData()
        allBooksCollectionView.reloadData()
    }
    
    func setupNavigation() {
        navigationItem.title = "BookLog"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let menuButton = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)
        menuButton.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = menuButton
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    func loadBooks() {
        let books = BookDataManager.shared.fetchBooks()
        reviewedBooks = books.filter { $0.review != nil && !$0.review!.isEmpty }
        allBooks = books
    }
    
    func setupCollectionViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        reviewedBooksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        reviewedBooksCollectionView.backgroundColor = .white
        reviewedBooksCollectionView.register(BookCollectionCell.self, forCellWithReuseIdentifier: BookCollectionCell.identifier)
        reviewedBooksCollectionView.dataSource = self
        reviewedBooksCollectionView.delegate = self
        
        allBooksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        allBooksCollectionView.backgroundColor = .white
        allBooksCollectionView.register(BookCollectionCell.self, forCellWithReuseIdentifier: BookCollectionCell.identifier)
        allBooksCollectionView.dataSource = self
        allBooksCollectionView.delegate = self
    }
    
    func setupLayout() {
        view.addSubview(allBooksLabel)
        view.addSubview(reviewedBooksLabel)
        view.addSubview(reviewedBooksCollectionView)
        view.addSubview(allBooksCollectionView)
        
        allBooksLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        allBooksCollectionView.snp.makeConstraints {
            $0.top.equalTo(allBooksLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
        
        reviewedBooksLabel.snp.makeConstraints{
            $0.top.equalTo(allBooksCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        reviewedBooksCollectionView.snp.makeConstraints {
            $0.top.equalTo(reviewedBooksLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
        
    }
    
}

extension BookLogViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == reviewedBooksCollectionView {
            return reviewedBooks.count
        } else {
            return allBooks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionCell.identifier, for: indexPath) as! BookCollectionCell
        
        if collectionView == reviewedBooksCollectionView {
            let book = reviewedBooks[indexPath.item]
            cell.configure(with: book)
        } else {
            let book = allBooks[indexPath.item]
            cell.configure(with: book)
        }
        
        return cell
    }
}

extension BookLogViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tapped Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                if collectionView == self.reviewedBooksCollectionView {
                    let book = self.reviewedBooks[indexPath.item]
                    self.deleteBook(book: book, from: &self.reviewedBooks, in: self.reviewedBooksCollectionView, at: indexPath)
                } else {
                    let book = self.allBooks[indexPath.item]
                    self.deleteBook(book: book, from: &self.allBooks, in: self.allBooksCollectionView, at: indexPath)
                }
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [deleteAction])
        }
        
        return config
    }
    
    func deleteBook(book: BookEntityModel, from books: inout [BookEntityModel], in collectionView: UICollectionView, at indexPath: IndexPath) {
        BookDataManager.shared.deleteBook(book: book)
        books.remove(at: indexPath.item)
        DispatchQueue.main.async{
            collectionView.reloadSections(IndexSet(integer: indexPath.row))
        }
    }
}

extension BookLogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.4
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}
