//
//  SearchViewController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    let helloLabel: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
}

// MARK: - Layout
extension SearchViewController {
    private func configureLayout() {
        self.title = "검색"
        
        view.backgroundColor = .white
        
        let components = [helloLabel]
        
        components.forEach { component in
            view.addSubview(component)
        }
    }
}

