//
//  HomeViewController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    var bookInfoController = HomeBookCollection()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<HomeBookCollection.BookSeries, HomeBookCollection.BookInfo>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<HomeBookCollection.BookSeries, HomeBookCollection.BookInfo>! = nil
    static let titleElementKind: String = "Book-To-You"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomeViewHierarchy()
        configureHomeViewDataSource()
    }
}

// MARK: - Layout
extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .fractionalHeight(0.9))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(0.279))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = -30
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 70, bottom: 30, trailing: 0)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: HomeViewController.titleElementKind, alignment: .top)
            
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}

extension HomeViewController {
    private func configureHomeViewHierarchy() {
        self.title = "홈"
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureHomeViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<HomeBookCollectionViewCell, HomeBookCollection.BookInfo> { (cell, indexPath, book) in
            cell.imageView.image = UIImage(named: book.imageName)
            cell.title.text = book.title
        }
        
        dataSource = UICollectionViewDiffableDataSource<HomeBookCollection.BookSeries, HomeBookCollection.BookInfo>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, book: HomeBookCollection.BookInfo) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: book)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleCollectionReusableView>(elementKind: HomeViewController.titleElementKind) { (supplementaryView, string, indexPath) in
            
            if let snapshot = self.currentSnapshot {
                let category = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = category.title
                print("Collection view implemented : \(category.title)")
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        
        currentSnapshot = NSDiffableDataSourceSnapshot<HomeBookCollection.BookSeries, HomeBookCollection.BookInfo>()
        bookInfoController.collections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.books)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedStuff = dataSource.itemIdentifier(for: indexPath) {
            let selectedStuffNumber = selectedStuff.bookId
            CurrentBookNumberManager.shared.writeCurrentBookNumber(Int(selectedStuffNumber))
        }
        
        let bookDetailViewController = DetailBookViewController()
        
        navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
}
