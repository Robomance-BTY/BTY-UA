//
//  DetailOrderView.swift
//  BookToYou
//
//  Created by ROLF J. on 4/25/24.
//

import UIKit
import SnapKit

class DetailOrderView: UIView {
    let stuffImageView: UIImageView = UIImageView()
    let stuffTitle: UILabel = UILabel()
    let price: UILabel = UILabel()
    let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.setBackgroundImage(color: .lightGray, forState: .highlighted)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
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

extension DetailOrderView {
    private func configure() {
        let component = [stuffImageView, stuffTitle, price, buyButton]
        component.forEach { component in
            self.addSubview(component)
        }
        
        stuffImageView.clipsToBounds = true
        stuffImageView.layer.cornerRadius = 15
        stuffImageView.layer.borderWidth = 1
        stuffImageView.layer.borderColor = UIColor.black.cgColor
        
        stuffImageView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.centerY).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(self.snp.width).multipliedBy(0.4)
        }
        
        stuffTitle.font = UIFont.boldSystemFont(ofSize: 25)
        stuffTitle.textColor = .black
        stuffTitle.textAlignment = .center
        stuffTitle.snp.makeConstraints { make in
            make.top.equalTo(stuffImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        price.font = UIFont.systemFont(ofSize: 17)
        price.textColor = .black
        price.textAlignment = .center
        price.snp.makeConstraints { make in
            make.top.equalTo(stuffTitle.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        buyButton.snp.makeConstraints { make in
            make.top.equalTo(price.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
    }
}
