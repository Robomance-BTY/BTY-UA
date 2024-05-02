//
//  DetailBookView.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import UIKit
import SnapKit

class DetailBookView: UIView {
    let bookImageView: UIImageView = UIImageView()
    let bookTitle: UILabel = UILabel()
    let scrollView: UIScrollView = UIScrollView()
    let bookDescription: UILabel = UILabel()
    let author: UILabel = UILabel()
    let genre: UILabel = UILabel()
    let country: UILabel = UILabel()
    let publishedDate: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("fatalError")
    }
}

extension DetailBookView {
    private func configure() {
        self.backgroundColor = .white
        
        self.addSubview(bookImageView)
        bookImageView.clipsToBounds = true
        bookImageView.layer.cornerRadius = 15
        bookImageView.layer.borderWidth = 1
        bookImageView.layer.borderColor = UIColor.black.cgColor
        
        self.addSubview(scrollView)
        scrollView.addSubview(bookDescription)
        let labels = [bookTitle, author, genre, country, publishedDate]
        labels.forEach { label in
            self.addSubview(label)
            
            label.textColor = .black
            label.textAlignment = .center
        }
        
        bookImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.width.equalTo(self.snp.width).multipliedBy(0.17)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        bookTitle.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.top)
            make.leading.equalTo(bookImageView.snp.trailing).offset(20)
        }
        bookTitle.font = UIFont.boldSystemFont(ofSize: 30)
        
        country.snp.makeConstraints { make in
            make.centerY.equalTo(bookTitle)
            make.leading.equalTo(bookTitle.snp.trailing).offset(10)
        }
        country.font = UIFont.boldSystemFont(ofSize: 30)
        
        author.snp.makeConstraints { make in
            make.top.equalTo(bookTitle.snp.bottom).offset(20)
            make.leading.equalTo(bookImageView.snp.trailing).offset(20)
        }
        author.font = UIFont.systemFont(ofSize: 20)
        
        genre.snp.makeConstraints { make in
            make.top.equalTo(author.snp.bottom).offset(10)
            make.leading.equalTo(bookImageView.snp.trailing).offset(20)
        }
        genre.font = UIFont.systemFont(ofSize: 20)
        
        publishedDate.snp.makeConstraints { make in
            make.top.equalTo(genre.snp.bottom).offset(10)
            make.leading.equalTo(bookImageView.snp.trailing).offset(20)
        }
        publishedDate.font = UIFont.systemFont(ofSize: 20)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(publishedDate.snp.bottom).offset(20)
            make.leading.equalTo(bookImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        bookDescription.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        bookDescription.textColor = .black
        bookDescription.font = UIFont.systemFont(ofSize: 17)
        bookDescription.textAlignment = .left
        bookDescription.numberOfLines = 0

        
        setComponents()
    }
    
    private func setComponents() {
        let currentBookInfo = allBookList[CurrentBookNumberManager.shared.getCurrentBookNumber()]
        
        bookImageView.image = UIImage(named: currentBookInfo.imageName)
        bookTitle.text = currentBookInfo.title
        country.text = currentBookInfo.country
        author.text = currentBookInfo.author
        genre.text = currentBookInfo.genre
        publishedDate.text = currentBookInfo.published
        bookDescription.text = currentBookInfo.description
    }
}
