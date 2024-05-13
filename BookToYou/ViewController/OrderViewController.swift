//
//  OrderViewController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import UIKit
import SnapKit

class OrderViewController: UIViewController {
    
    var collectionView: UICollectionView! = nil
    let orderStuffController = OrderStuffController()
    var dataSource: UICollectionViewDiffableDataSource<OrderStuffController.OrderInfoCollection, OrderStuffController.OrderInfo>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<OrderStuffController.OrderInfoCollection, OrderStuffController.OrderInfo>! = nil
    static let titleElementKind: String = "Book-To-You"

    override func viewDidLoad() {
        super.viewDidLoad()

        configureOrderCollectionViewHierarchy()
        configureOrderCollectionViewDataSource()
    }
}

// MARK: - Layout
extension OrderViewController {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = -80
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 30, bottom: 30, trailing: 0)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: OrderViewController.titleElementKind, alignment: .top)
            
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}

extension OrderViewController {
    private func configureOrderCollectionViewHierarchy() {
        self.title = "주문"
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureOrderCollectionViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<OrderCollectionViewCell, OrderStuffController.OrderInfo> { (cell, indexPath, stuff) in
            cell.imageView.image = UIImage(named: stuff.stuffName)
            cell.title.text = stuff.title
        }
        
        dataSource = UICollectionViewDiffableDataSource<OrderStuffController.OrderInfoCollection, OrderStuffController.OrderInfo>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, stuff: OrderStuffController.OrderInfo) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: stuff)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleCollectionReusableView>(elementKind: OrderViewController.titleElementKind) { supplementary, elementKind, indexPath in
            if let snapshot = self.currentSnapshot {
                let category = snapshot.sectionIdentifiers[indexPath.section]
                supplementary.label.text = category.stuffsTitle
                print("Collection view implemented : \(category.stuffsTitle)")
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        
        currentSnapshot = NSDiffableDataSourceSnapshot<OrderStuffController.OrderInfoCollection, OrderStuffController.OrderInfo>()
        orderStuffController.collections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.stuffs)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

extension OrderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected order stuff : \(stuffs[indexPath.item])")
        
        if let selectedStuff = dataSource.itemIdentifier(for: indexPath) {
            let selectedStuffNumber = selectedStuff.orderId
            OrderStuffNumberManager.shared.writeOrderStuffNumber(Int(selectedStuffNumber))
        }
        
        let orderDetailViewController = DetailOrderViewController()
        
        orderDetailViewController.modalPresentationStyle = .pageSheet
        
        self.present(orderDetailViewController, animated: true)
    }
}
