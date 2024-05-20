//
//  MyView.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import UIKit
import SnapKit

class MyView: UIView {
    
    let borrowedLabel: UILabel = UILabel()
    let borrowedBackground1: UIView = UIView()
    let borrowedImageView1: UIImageView = UIImageView()
    var borrowedButton1: UIButton = UIButton()
    let borrowedBackground2: UIView = UIView()
    let borrowedImageView2: UIImageView = UIImageView()
    var borrowedButton2: UIButton = UIButton()
    let borrowedBackground3: UIView = UIView()
    let borrowedImageView3: UIImageView = UIImageView()
    var borrowedButton3: UIButton = UIButton()
    let borrowedBackground4: UIView = UIView()
    let borrowedImageView4: UIImageView = UIImageView()
    var borrowedButton4: UIButton = UIButton()
    let borrowedBackground5: UIView = UIView()
    let borrowedImageView5: UIImageView = UIImageView()
    var borrowedButton5: UIButton = UIButton()
    
    let willBorrowLabel: UILabel = UILabel()
    let willBorrowBackground1: UIView = UIView()
    let willBorrowImageView1: UIImageView = UIImageView()
    var willBorrowButton1: UIButton = UIButton()
    let willBorrowBackground2: UIView = UIView()
    let willBorrowImageView2: UIImageView = UIImageView()
    var willBorrowButton2: UIButton = UIButton()
    let willBorrowBackground3: UIView = UIView()
    let willBorrowImageView3: UIImageView = UIImageView()
    var willBorrowButton3: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("fatalError")
    }
}

extension MyView {
    private func configure() {
        let labels = [borrowedLabel, willBorrowLabel]
        labels.forEach { label in
            self.addSubview(label)
            
            label.textColor = .black
            label.textAlignment = .center
            label.font = .boldSystemFont(ofSize: 20)
        }
        
        let backgrounds = [borrowedBackground1, borrowedBackground2, borrowedBackground3, borrowedBackground4, borrowedBackground5, willBorrowBackground1, willBorrowBackground2, willBorrowBackground3]
        backgrounds.forEach { background in
            self.addSubview(background)
            
            background.layer.cornerRadius = 20
            background.layer.borderWidth = 0.5
            background.layer.borderColor = UIColor.lightGray.cgColor
            background.layer.shadowColor = UIColor.black.cgColor
            background.layer.shadowRadius = 0.5
            background.layer.shadowOffset = CGSize(width: 0, height: 0)
            background.layer.shadowOpacity = 1.0
        }
        
        let imageViews = [borrowedImageView1, borrowedImageView2, borrowedImageView3, borrowedImageView4, borrowedImageView5, willBorrowImageView1, willBorrowImageView2, willBorrowImageView3]
        imageViews.forEach { imageView in
            self.addSubview(imageView)
            
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 13
            imageView.layer.borderWidth = 0.7
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowRadius = 0.5
            imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
            imageView.layer.shadowOpacity = 1.0
            imageView.image = UIImage(named: "plusIcon")
            imageView.contentMode = .scaleAspectFill
        }
        
        let buttons = [borrowedButton1, borrowedButton2, borrowedButton3, borrowedButton4, borrowedButton5, willBorrowButton1, willBorrowButton2, willBorrowButton3]
        buttons.forEach { button in
            self.addSubview(button)
            
            button.clipsToBounds = true
            button.backgroundColor = .clear
            button.layer.cornerRadius = 13
            button.isUserInteractionEnabled = true
        }
        
        borrowedLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        borrowedLabel.text = "현재 빌린 책"
        
        borrowedBackground3.snp.makeConstraints { make in
            make.top.equalTo(borrowedLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.16)
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        borrowedBackground2.snp.makeConstraints { make in
            make.top.equalTo(borrowedLabel.snp.bottom)
            make.trailing.equalTo(borrowedBackground3.snp.leading).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.16)
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        borrowedBackground1.snp.makeConstraints { make in
            make.top.equalTo(borrowedLabel.snp.bottom)
            make.trailing.equalTo(borrowedBackground2.snp.leading).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.16)
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        borrowedBackground4.snp.makeConstraints { make in
            make.top.equalTo(borrowedLabel.snp.bottom)
            make.leading.equalTo(borrowedBackground3.snp.trailing).offset(20)
            make.width.equalToSuperview().multipliedBy(0.16)
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        borrowedBackground5.snp.makeConstraints { make in
            make.top.equalTo(borrowedLabel.snp.bottom)
            make.leading.equalTo(borrowedBackground4.snp.trailing).offset(20)
            make.width.equalToSuperview().multipliedBy(0.16)
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        willBorrowLabel.snp.makeConstraints { make in
            make.top.equalTo(borrowedBackground3.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        willBorrowLabel.text = "예약된 책"
        
        willBorrowBackground2.snp.makeConstraints { make in
            make.top.equalTo(willBorrowLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.16)
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        willBorrowBackground1.snp.makeConstraints { make in
            make.top.equalTo(willBorrowLabel.snp.bottom)
            make.trailing.equalTo(willBorrowBackground2.snp.leading).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.16)
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        willBorrowBackground3.snp.makeConstraints { make in
            make.top.equalTo(willBorrowLabel.snp.bottom)
            make.leading.equalTo(willBorrowBackground2.snp.trailing).offset(20)
            make.width.equalToSuperview().multipliedBy(0.16)
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        borrowedImageView1.snp.makeConstraints { make in
            make.center.equalTo(borrowedBackground1.snp.center)
            make.width.equalTo(borrowedBackground1.snp.width).multipliedBy(0.90)
            make.height.equalTo(borrowedBackground1.snp.height).multipliedBy(0.93)
        }
        borrowedButton1.snp.makeConstraints { make in
            make.center.width.height.equalTo(borrowedImageView1)
        }
        
        borrowedImageView2.snp.makeConstraints { make in
            make.center.equalTo(borrowedBackground2.snp.center)
            make.width.equalTo(borrowedBackground2.snp.width).multipliedBy(0.90)
            make.height.equalTo(borrowedBackground2.snp.height).multipliedBy(0.93)
        }
        borrowedButton2.snp.makeConstraints { make in
            make.center.width.height.equalTo(borrowedImageView2)
        }
        
        borrowedImageView3.snp.makeConstraints { make in
            make.center.equalTo(borrowedBackground3.snp.center)
            make.width.equalTo(borrowedBackground3.snp.width).multipliedBy(0.90)
            make.height.equalTo(borrowedBackground3.snp.height).multipliedBy(0.93)
        }
        borrowedButton3.snp.makeConstraints { make in
            make.center.width.height.equalTo(borrowedImageView3)
        }
        
        borrowedImageView4.snp.makeConstraints { make in
            make.center.equalTo(borrowedBackground4.snp.center)
            make.width.equalTo(borrowedBackground4.snp.width).multipliedBy(0.90)
            make.height.equalTo(borrowedBackground4.snp.height).multipliedBy(0.93)
        }
        borrowedButton4.snp.makeConstraints { make in
            make.center.width.height.equalTo(borrowedImageView4)
        }
        
        borrowedImageView5.snp.makeConstraints { make in
            make.center.equalTo(borrowedBackground5.snp.center)
            make.width.equalTo(borrowedBackground5.snp.width).multipliedBy(0.90)
            make.height.equalTo(borrowedBackground5.snp.height).multipliedBy(0.93)
        }
        borrowedButton5.snp.makeConstraints { make in
            make.center.width.height.equalTo(borrowedImageView5)
        }
        
        willBorrowImageView1.snp.makeConstraints { make in
            make.center.equalTo(willBorrowBackground1.snp.center)
            make.width.equalTo(willBorrowBackground1.snp.width).multipliedBy(0.90)
            make.height.equalTo(willBorrowBackground1.snp.height).multipliedBy(0.93)
        }
        willBorrowButton1.snp.makeConstraints { make in
            make.center.width.height.equalTo(willBorrowImageView1)
        }
        
        willBorrowImageView2.snp.makeConstraints { make in
            make.center.equalTo(willBorrowBackground2.snp.center)
            make.width.equalTo(willBorrowBackground2.snp.width).multipliedBy(0.90)
            make.height.equalTo(willBorrowBackground2.snp.height).multipliedBy(0.93)
        }
        willBorrowButton2.snp.makeConstraints { make in
            make.center.width.height.equalTo(willBorrowImageView2)
        }
        
        willBorrowImageView3.snp.makeConstraints { make in
            make.center.equalTo(willBorrowBackground3.snp.center)
            make.width.equalTo(willBorrowBackground3.snp.width).multipliedBy(0.90)
            make.height.equalTo(willBorrowBackground3.snp.height).multipliedBy(0.93)
        }
        willBorrowButton3.snp.makeConstraints { make in
            make.center.width.height.equalTo(willBorrowImageView3)
        }
    }
}
