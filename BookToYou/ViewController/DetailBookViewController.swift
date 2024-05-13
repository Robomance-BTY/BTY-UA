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
            
            print("setComponents: \(CurrentBookNumberManager.shared.getCurrentBookNumber())")
            
            self?.bookSeriesView.collectionView.reloadData()
            self?.configureBorrowButton(CurrentBookNumberManager.shared.getCurrentBookStatus())
        }
        
        bookSeriesView.dataSource = bookSeries
    }
    
    public func configureBorrowButton(_ status: BookStatus) {
        borrowButton.clipsToBounds = true
        borrowButton.layer.cornerRadius = 10
        borrowButton.setTitleColor(.white, for: .normal)
        
        if status == BookStatus.normal {
            borrowButton.setTitle("대여하기", for: .normal)
            borrowButton.backgroundColor = .systemBlue
            borrowButton.setBackgroundImage(color: .lightGray, forState: .highlighted)
        } else if status == BookStatus.borrowed {
            borrowButton.setTitle("반납하기", for: .normal)
            borrowButton.backgroundColor = .systemRed
            borrowButton.setBackgroundImage(color: .lightGray, forState: .highlighted)
        } else if status == BookStatus.booked {
            borrowButton.setTitle("예약중", for: .normal)
            borrowButton.backgroundColor = .systemGreen
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
        if CurrentBookNumberManager.shared.getCurrentBookStatus() == BookStatus.normal {
            print("This book is not borrowed")
            let willBorrow = UIAlertController(title: "도서 대여", message: "책을 대여하시겠습니까?", preferredStyle: .alert)
            willBorrow.addAction(UIAlertAction(title: "취소", style: .cancel))
            willBorrow.addAction(UIAlertAction(title: "대여", style: .default, handler: { [weak self] _ in
                guard self != nil else { return }
                self?.rentBook()
                MyViewController.shared.reloadButtons()
            }))
            self.present(willBorrow, animated: true, completion: nil)
        } else if CurrentBookNumberManager.shared.getCurrentBookStatus() == BookStatus.borrowed {
            print("This book is already borrwed")
            let willReturn = UIAlertController(title: "도서 반납", message: "책을 반납하시겠습니까?", preferredStyle: .alert)
            willReturn.addAction(UIAlertAction(title: "취소", style: .cancel))
            willReturn.addAction(UIAlertAction(title: "반납", style: .default, handler: { [weak self] _ in
                guard self != nil else { return }
                self?.returnBook()
            }))
            self.present(willReturn, animated: true, completion: nil)
        } else if CurrentBookNumberManager.shared.getCurrentBookStatus() == BookStatus.booked {
            print("This book is booked")
            let willCancel = UIAlertController(title: "예약중", message: nil, preferredStyle: .alert)
            willCancel.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(willCancel, animated: true, completion: nil)
        }
    }
    
    func rentBook() {
        print("------------------------------------------------------------")
        print("rentBook")
        let originalList = CurrentBookNumberManager.shared.getCurrentBorrowedList()
        print("Current borrowed list: \(originalList)")
        let reservationList = CurrentBookNumberManager.shared.getNextWillBorrowList()
        print("Current reservation list: \(reservationList)")
        var newList: [Int] = []
        
        // 0 <= Borrowed < 3, (Borrowed+Reservation) < 5
        if originalList.count >= 0 && originalList.count < 3 && (originalList.count + reservationList.count) < 5 {
            print("originalList + ReservationList is not full")
            let selectedBookNumber = CurrentBookNumberManager.shared.getCurrentBookNumber()
            print("selectedBookNumber: \(CurrentBookNumberManager.shared.getCurrentBookNumber())")
            let selectedBookIndex = AllBookList.shared.allBookList.firstIndex { $0.bookId == selectedBookNumber }
            print("SelectedBook is: \(AllBookList.shared.allBookList[selectedBookIndex ?? 0].title)")
            if AllBookList.shared.allBookList[selectedBookIndex ?? 0].currentStatus == .borrowed {
                let alreadyBorrowedAlert = UIAlertController(title: "대여중", message: "대여중인 책입니다. 예약하시겠습니까?", preferredStyle: .alert)
                alreadyBorrowedAlert.addAction(UIAlertAction(title: "확인", style: .default))
                alreadyBorrowedAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
                self.present(alreadyBorrowedAlert, animated: true) {
                    self.reservationBook()
                    print("------------------------------------------------------------")
                }
            } else {
                newList = originalList
                AllBookList.shared.allBookList[selectedBookIndex ?? 0].currentStatus = .borrowed
                print("Selected book's current status: \(AllBookList.shared.allBookList[selectedBookIndex ?? 0].currentStatus)")
                newList.append(AllBookList.shared.allBookList[selectedBookIndex ?? 0].bookId)
                print("NewList: \(newList)")
                CurrentBookNumberManager.shared.writeCurrentBorrowedList(newList)
                MyViewController.shared.reloadButtons()
                configureBorrowButton(CurrentBookNumberManager.shared.getCurrentBookStatus())
                print("------------------------------------------------------------")
                navigationController?.popViewController(animated: true)
            }
        } else {
            rentOverAlert()
        }
    }
    
    func rentOverAlert() {
        let rentOver = UIAlertController(title: "대여량 초과", message: "대여/예약 포함 책은 5권까지만 대여하실 수 있습니다", preferredStyle: .alert)
        rentOver.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(rentOver, animated: true, completion: nil)
    }
    
    func returnBook() {
        var borrowedList = CurrentBookNumberManager.shared.getCurrentBorrowedList()
        let removeId = CurrentBookNumberManager.shared.getCurrentBookNumber()
        print("removeId: \(removeId)")
        
        let selectedBookIndex = AllBookList.shared.allBookList.firstIndex { $0.bookId == removeId } ?? 0
        let selectedRemoveIndex = borrowedList.firstIndex { $0 == removeId } ?? 0
        AllBookList.shared.allBookList[selectedBookIndex].currentStatus = .normal
        borrowedList.remove(at: selectedRemoveIndex)
        print("returnBook: \(borrowedList)")
        CurrentBookNumberManager.shared.writeCurrentBorrowedList(borrowedList)
        configureBorrowButton(CurrentBookNumberManager.shared.getCurrentBookStatus())
        navigationController?.popViewController(animated: true)
        MyViewController.shared.reloadButtons()
        MyViewController.shared.reloadInputViews()
    }
    
    func reservationBook() {
        let originalList = CurrentBookNumberManager.shared.getNextWillBorrowList()
        let borrowedList = CurrentBookNumberManager.shared.getCurrentBorrowedList()
        var newList: [Int] = []
        
        if originalList.count >= 0 && originalList.count < 3 && (originalList.count + borrowedList.count) < 5 {
            let selectedBookNumber = CurrentBookNumberManager.shared.getCurrentBookNumber()
            let selectedBookIndex = AllBookList.shared.allBookList.firstIndex { $0.bookId == selectedBookNumber }
            AllBookList.shared.allBookList[selectedBookIndex ?? 0].currentStatus = .booked
            newList.append(AllBookList.shared.allBookList[selectedBookIndex ?? 0].bookId)
            CurrentBookNumberManager.shared.writeNextWillBorrowList(newList)
            configureBorrowButton(CurrentBookNumberManager.shared.getCurrentBookStatus())
            MyViewController.shared.reloadButtons()
            navigationController?.popViewController(animated: true)
        } else {
            rentOverAlert()
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
