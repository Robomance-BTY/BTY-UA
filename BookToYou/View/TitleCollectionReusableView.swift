//
//  TitleCollectionReusableView.swift
//  BookToYou
//
//  Created by ROLF J. on 4/23/24.
//

import UIKit

class TitleCollectionReusableView: UICollectionReusableView {
        
    let label = UILabel()
    static let reuseIdentifier = "titleSupplementaryReusableIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
}

extension TitleCollectionReusableView {
    private func configure() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .black
    }
}
