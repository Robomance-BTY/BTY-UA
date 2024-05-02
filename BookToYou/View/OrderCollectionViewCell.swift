//
//  OrderCollectionViewCell.swift
//  BookToYou
//
//  Created by ROLF J. on 4/25/24.
//

import UIKit
import SnapKit

class OrderCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "orderCellReuseIdentifier"
    
    let imageBackground: UIView = UIView()
    let imageView: UIImageView = UIImageView()
    let title: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
}

extension OrderCollectionViewCell {
    private func configure() {
        contentView.addSubview(imageBackground)
        contentView.addSubview(imageView)
        contentView.addSubview(title)
        
        imageBackground.layer.cornerRadius = 20
        imageBackground.layer.borderWidth = 0.5
        imageBackground.layer.borderColor = UIColor.lightGray.cgColor
        imageBackground.layer.shadowColor = UIColor.black.cgColor
        imageBackground.layer.shadowRadius = 1.0
        imageBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageBackground.layer.shadowOpacity = 1.0
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 13
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 1.0
        imageView.backgroundColor = .systemGray
        
        title.font = .boldSystemFont(ofSize: 17)
        title.textColor = .black
        title.textAlignment = .center
        
        imageBackground.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalTo(imageBackground.snp.center)
            make.width.equalTo(imageBackground.snp.width).multipliedBy(0.92)
            make.height.equalTo(imageBackground.snp.height).multipliedBy(0.93)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(imageBackground.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
}
