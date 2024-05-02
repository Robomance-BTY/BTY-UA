//
//  DetailOrderViewController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/25/24.
//

import UIKit
import SnapKit

class DetailOrderViewController: UIViewController {
    
    let detailView: UIView = DetailOrderView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
}

extension DetailOrderViewController {
    private func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide
            )
        }
    }
}

extension DetailOrderViewController {
    
}
