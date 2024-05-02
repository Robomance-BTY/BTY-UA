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
        let component = [stuffImageView, stuffTitle, price]
        component.forEach { component in
            self.addSubview(component)
        }
        
        stuffImageView.clipsToBounds = true
        stuffImageView.layer.cornerRadius = 15
        stuffImageView.layer.borderWidth = 1
        stuffImageView.layer.borderColor = UIColor.black.cgColor
        
        stuffImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(self.snp.height).multipliedBy(0.25)
        }
        
        stuffTitle.font = UIFont.boldSystemFont(ofSize: 25)
        stuffTitle.textColor = .black
        stuffTitle.textAlignment = .center
        stuffTitle.snp.makeConstraints { make in
            make.top.equalTo(stuffImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        price.font = UIFont.systemFont(ofSize: 17)
        price.textColor = .black
        price.textAlignment = .center
        price.snp.makeConstraints { make in
            make.top.equalTo(stuffTitle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        setComponents()
    }
    
    private func setComponents() {
        let currentStuffInfo = stuffs[OrderStuffNumberManager.shared.getOrderStuffNumber()]
        
        stuffImageView.image = UIImage(named: currentStuffInfo.stuffName)
        stuffTitle.text = currentStuffInfo.title
        price.text = String(Int(currentStuffInfo.price)) + "원"
    }
}
