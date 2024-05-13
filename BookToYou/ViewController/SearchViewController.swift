//
//  SearchViewController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    let searchController = UISearchController(searchResultsController: nil)
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 60
        layout.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var allBooks: [BookInfo] = []
    var filteredBooks: [BookInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchController()
        configureCollectionView()
        
        loadBooks()
        
        filteredBooks = allBooks
        collectionView.reloadData()
    }
}

// MARK: - Layout
extension SearchViewController {
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "제목, 작가, 장르 검색"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.clipsToBounds = true
            textField.backgroundColor = .white
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.layer.cornerRadius = 10.0
        }
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeBookCollectionViewCell.self, forCellWithReuseIdentifier: HomeBookCollectionViewCell.reuseIdentifier)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    private func loadBooks() {
        allBooks = AllBookList.shared.allBookList
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBookCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeBookCollectionViewCell else {
            fatalError()
        }
        
        let book = filteredBooks[indexPath.item]
        cell.imageView.image = UIImage(named: book.imageName)
        cell.title.text = book.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) / 6
        let height = width * 1.5 + 10
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = filteredBooks[indexPath.item]
        print("filteredSelectedBook: \(selectedBook)")
        let seletedBookId = selectedBook.bookId
        CurrentBookNumberManager.shared.writeCurrentBookNumber(Int(seletedBookId))
        print("selectedBookId: \(seletedBookId)")
        
        let bookDetailViewController = DetailBookViewController()
        navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            filteredBooks = allBooks
        } else {
            filteredBooks = allBooks.filter({ book in
                return book.title.contains(searchText) || book.author.contains(searchText) || book.genre.contains(searchText)
            })
        }
        
        collectionView.reloadData()
    }
}
