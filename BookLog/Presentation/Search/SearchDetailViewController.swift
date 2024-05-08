//
//  SearchDetailViewController.swift
//  BookLog
//
//  Created by 박현렬 on 5/7/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class SearchDetailViewController: UIViewController{
    
    // MARK: - UI Components
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)).then {
        $0.alpha = 0.8
    }
    
    let bookImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = UILabel().then{
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.numberOfLines = 0
    }
    
    let authorLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    
    let publisherLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    
    let contentsLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    
    let closeButton = UIButton().then {
        var configuration = UIButton.Configuration.tinted()
        configuration.image = UIImage(systemName: "xmark")
        configuration.baseForegroundColor = .white
        configuration.background.backgroundColor = .gray
        configuration.cornerStyle = .large
        
        $0.configuration = configuration
    }
    
    let saveButton = UIButton().then{
        var configuration = UIButton.Configuration.tinted()
        configuration.image = UIImage(systemName: "bookmark")
        configuration.title = "담기"
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 10
        configuration.baseForegroundColor = .white
        configuration.background.backgroundColor = .gray
        configuration.cornerStyle = .large
        
        
        $0.configuration = configuration
    }
    
    var book: Book?
    
    var bookEntity: BookEntityModel?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupData()
        addTarget()
    }
    
    // MARK: - Setup
    
    func setupLayout(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(blurEffectView)
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(publisherLabel)
        contentView.addSubview(contentsLabel)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(view.frame.height / 2)
        }
        
        blurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bookImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(view.frame.height / 2)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(blurEffectView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        authorLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
        
        publisherLabel.snp.makeConstraints{
            $0.top.equalTo(authorLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
        
        contentsLabel.snp.makeConstraints{
            $0.top.equalTo(publisherLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-150)
        }
        
        closeButton.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.leading.equalTo(closeButton.snp.trailing).offset(10)
            $0.height.equalTo(50)
        }
    }
    
    func addTarget() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        guard let book = book else { return }
        let bookEntityModel = BookEntityModel(authors: book.authors.joined(separator: ", "), contents: book.contents, publisher: book.publisher, thumbnail: book.thumbnail, title: book.title, review: nil)
        BookDataManager.shared.saveBook(book: bookEntityModel)
        dismiss(animated: true, completion: nil)
    }
    
    func setupData() {
        guard let book = book else { return }
        
        backgroundImageView.kf.setImage(with: URL(string: book.thumbnail))
        bookImageView.kf.setImage(with: URL(string: book.thumbnail))
        titleLabel.text = book.title
        authorLabel.text = book.authors.joined(separator: ", ")
        publisherLabel.text = book.publisher
        contentsLabel.text = book.contents
        
        bookEntity = BookEntityModel(authors: book.authors.joined(separator: ", "), contents: book.contents, publisher: book.publisher, thumbnail: book.thumbnail, title: book.title, review: nil)
    }
}

