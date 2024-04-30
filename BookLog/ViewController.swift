//
//  ViewController.swift
//  BookLog
//
//  Created by 박현렬 on 5/1/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
        BookAPIManager.shared.searchBookData(esearchText: "세이노") { result in
            switch result{
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }


}

