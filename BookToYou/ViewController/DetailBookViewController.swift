//
//  DetailBookViewController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import UIKit
import SnapKit

class DetailBookViewController: UIViewController {
    
    let detailView: DetailBookView = DetailBookView()
    let bookSeriesView: BookSeriesView = BookSeriesView()
    let borrowButton: UIButton = UIButton()
    
    var selectedSeries: [BookInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        setComponents()
        configureBorrowButton(CurrentBookNumberManager.shared.getCurrentBookStatus())
    }
}

// MARK: - Layout
extension DetailBookViewController {
    private func configureLayout() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "돌아가기", style: .plain, target: self, action: #selector(goBack))
        
        view.addSubview(borrowButton)
        borrowButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.2)
            make.height.equalTo(40)
        }
        
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(borrowButton.snp.top).offset(-20)
        }
        
        view.addSubview(bookSeriesView)
        bookSeriesView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.top.equalTo(borrowButton.snp.bottom).offset(40)
        }
    }
    
    private func setComponents() {
        let bookSeries: [BookInfo] = CurrentBookNumberManager.shared.getSeries()
        bookSeriesView.didSelectItem = { [weak self] selectedBook in
            self?.detailView.bookImageView.image = UIImage(named: selectedBook.imageName)
            self?.detailView.bookTitle.text = selectedBook.title
            self?.detailView.bookDescription.text = selectedBook.description
            self?.detailView.author.text = selectedBook.author
            self?.detailView.genre.text = selectedBook.genre
            self?.detailView.country.text = selectedBook.country
            self?.detailView.publishedDate.text = selectedBook.published
            
            self?.bookSeriesView.collectionView.reloadData()
        }
        
        bookSeriesView.dataSource = bookSeries
    }
    
    public func configureBorrowButton(_ status: CurrentBookNumberManager.BookStatus) {
        borrowButton.clipsToBounds = true
        borrowButton.layer.cornerRadius = 10
        borrowButton.setTitleColor(.white, for: .normal)
        
        if status == CurrentBookNumberManager.BookStatus.normal {
            borrowButton.setTitle("대여하기", for: .normal)
            borrowButton.backgroundColor = .systemBlue
            borrowButton.setBackgroundImage(color: .lightGray, forState: .highlighted)
        } else if status == CurrentBookNumberManager.BookStatus.borrowed {
            borrowButton.setTitle("반납하기", for: .normal)
            borrowButton.setTitleColor(.systemGreen, for: .normal)
            borrowButton.setBackgroundImage(color: .lightGray, forState: .highlighted)
        } else if status == CurrentBookNumberManager.BookStatus.booked {
            borrowButton.setTitle("예약취소", for: .normal)
            borrowButton.setTitleColor(.systemRed, for: .normal)
            borrowButton.setBackgroundImage(color: .lightGray, forState: .highlighted)
        }
        
        borrowButton.addTarget(self, action: #selector(borrowButtonClicked), for: .touchUpInside)
    }
}

extension DetailBookViewController {
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func borrowButtonClicked() {
        if CurrentBookNumberManager.shared.getCurrentBookStatus() == CurrentBookNumberManager.BookStatus.normal {
            let willBorrow = UIAlertController(title: "도서 대여", message: "책을 대여하시겠습니까?", preferredStyle: .alert)
            willBorrow.addAction(UIAlertAction(title: "취소", style: .cancel))
            willBorrow.addAction(UIAlertAction(title: "대여", style: .default, handler: { [weak self] _ in
                guard self != nil else { return }
                MyViewController.shared.getBookInfoAndApplication(CurrentBookNumberManager.shared.getCurrentBookNumber())
            }))
            self.present(willBorrow, animated: true, completion: nil)
        } else if CurrentBookNumberManager.shared.getCurrentBookStatus() == CurrentBookNumberManager.BookStatus.borrowed {
            let willReturn = UIAlertController(title: "도서 반납", message: "책을 반납하시겠습니까?", preferredStyle: .alert)
            willReturn.addAction(UIAlertAction(title: "취소", style: .cancel))
            willReturn.addAction(UIAlertAction(title: "반납", style: .default, handler: { [weak self] _ in
                guard self != nil else { return }
                MyViewController.shared.returnBook(CurrentBookNumberManager.shared.getCurrentBookNumber())
            }))
            self.present(willReturn, animated: true, completion: nil)
        } else if CurrentBookNumberManager.shared.getCurrentBookStatus() == CurrentBookNumberManager.BookStatus.booked {
            let willCancel = UIAlertController(title: "예약 취소", message: "예약을 취소하시겠습니까?", preferredStyle: .alert)
            willCancel.addAction(UIAlertAction(title: "취소", style: .cancel))
            willCancel.addAction(UIAlertAction(title: "예약취소", style: .default, handler: { [weak self] _ in
                guard self != nil else { return }
                MyViewController.shared.bookCancel(CurrentBookNumberManager.shared.getCurrentBookNumber())
            }))
            self.present(willCancel, animated: true, completion: nil)
        }
    }
}

extension UIButton {
    func setBackgroundImage(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
