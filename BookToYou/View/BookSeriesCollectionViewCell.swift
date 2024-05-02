//
//  BookSeriesCollectionViewCell.swift
//  BookToYou
//
//  Created by ROLF J. on 4/30/24.
//

import UIKit
import SnapKit

class BookSeriesCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "BookSeriesCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1.0
        imageView.layer.shadowRadius = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError()
    }
}

extension BookSeriesCollectionViewCell {
    private func configure() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(contentView.safeAreaLayoutGuide).multipliedBy(0.8)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}
