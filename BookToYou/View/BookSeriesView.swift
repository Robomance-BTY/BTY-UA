//
//  BookSeriesView.swift
//  BookToYou
//
//  Created by ROLF J. on 4/30/24.
//

import UIKit
import SnapKit

class BookSeriesView: UIView {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    var dataSource: [BookInfo] = [] {
        didSet {
            reloadView()
        }
    }
    
    var didSelectItem: ((BookInfo) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError()
    }
}

extension BookSeriesView {
    private func setupLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BookSeriesCollectionViewCell.self, forCellWithReuseIdentifier: BookSeriesCollectionViewCell.reuseIdentifier)
    }
    
    private func reloadView() {
        collectionView.reloadData()
    }
}

extension BookSeriesView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = dataSource[indexPath.item]
        CurrentBookNumberManager.shared.writeCurrentBookNumber(selectedBook.bookId)
        
        didSelectItem?(selectedBook)
        reloadView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookSeriesCollectionViewCell.reuseIdentifier, for: indexPath) as? BookSeriesCollectionViewCell else {
            fatalError()
        }
        
        let book = dataSource[indexPath.item]
        cell.imageView.image = UIImage(named: book.imageName)
        cell.titleLabel.text = book.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height * 0.6, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}
