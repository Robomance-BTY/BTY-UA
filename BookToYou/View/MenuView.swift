//
//  MenuView.swift
//  BookToYou
//
//  Created by ROLF J. on 4/26/24.
//

import UIKit
import SnapKit

class MenuView: UIView {
    static let shared = MenuView()
    
    let usedTimeDescription: UILabel = UILabel()
    let priceDescription: UILabel = UILabel()
    let timeDesctipion: UILabel = UILabel()
    var usedTime: UITextField = UITextField()
    var price: UITextField = UITextField()
    var todayDate: UITextField = UITextField()
    
//    let logOutButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError("fatalError")
    }
}

extension MenuView {
    private func configure() {
        let descriptions = [usedTimeDescription, priceDescription, timeDesctipion]
        descriptions.forEach { currentLabel in
            self.addSubview(currentLabel)
            currentLabel.font = .boldSystemFont(ofSize: 25)
            currentLabel.textColor = .black
            currentLabel.textAlignment = .center
        }
        
        let textFields = [usedTime, price, todayDate]
        textFields.forEach { textField in
            self.addSubview(textField)
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 15
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.shadowOffset = CGSize(width: 0, height: 0)
            textField.layer.shadowOpacity = 1
            textField.layer.shadowRadius = 0.5
            textField.layer.shadowColor = UIColor.black.cgColor
            
            textField.textColor = .black
            textField.textAlignment = .center
            textField.isUserInteractionEnabled = false
        }
        
//        self.addSubview(logOutButton)
//        logOutButton.clipsToBounds = true
//        logOutButton.layer.cornerRadius = 15
//        logOutButton.setTitle("로그아웃", for: .normal)
//        logOutButton.setTitleColor(.white, for: .normal)
//        logOutButton.backgroundColor = .systemRed
        
        price.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.snp.width).multipliedBy(0.3)
            make.height.equalTo(self.snp.height).multipliedBy(0.07)
        }
        
        priceDescription.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(price.snp.top).offset(-5)
        }
        priceDescription.text = "예상 요금"
        
        usedTime.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(priceDescription.snp.top).offset(-10)
            make.width.equalTo(self.snp.width).multipliedBy(0.3)
            make.height.equalTo(self.snp.height).multipliedBy(0.07)
        }
        
        usedTimeDescription.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(usedTime.snp.top).offset(-5)
        }
        usedTimeDescription.text = "사용 시간"
        
        timeDesctipion.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(price.snp.bottom).offset(10)
        }
        timeDesctipion.text = "오늘 날짜"
        
        todayDate.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeDesctipion.snp.bottom).offset(5)
            make.width.equalTo(self.snp.width).multipliedBy(0.3)
            make.height.equalTo(self.snp.height).multipliedBy(0.07)
        }
        
//        logOutButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-30)
//            make.width.equalTo(self.snp.width).multipliedBy(0.2)
//            make.height.equalTo(self.snp.height).multipliedBy(0.07)
//        }
    }
}
