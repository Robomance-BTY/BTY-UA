//
//  DetailBookViewController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class DetailBookViewController: UIViewController {
    
    var checkStatusTimer: Timer?
    
    var onDismiss: (() -> Void)?
    
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
                self?.checkBookRented()
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
    
    func checkBookRented() {
        let loadingView = UIView(frame: self.view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        loadingView.isUserInteractionEnabled = true
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballPulse, color: .white, padding: nil)
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        self.view.addSubview(loadingView)
        
        let selectedBookNumber = CurrentBookNumberManager.shared.getCurrentBookNumber()
        let numberForRequest: UInt64
        
        if selectedBookNumber / 20000 == 0 {
            numberForRequest = UInt64(selectedBookNumber % 10000)
        } else {
            numberForRequest = UInt64((selectedBookNumber % 20000) - 7)
        }
        
        APIManager.shared.changeCurrentAPIRequestBookID(UInt64(numberForRequest))
        
        // True -> Already rented
        APIManager.shared.methodForReserve { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    activityIndicator.stopAnimating()
                    loadingView.removeFromSuperview()
                    
                    let alreadyBorrowedAlert = UIAlertController(title: "대여중", message: "대여중인 책입니다. 예약하시겠습니까?", preferredStyle: .alert)
                    alreadyBorrowedAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self?.rentOrReservationBook()
                    }))
                    alreadyBorrowedAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
                    self?.present(alreadyBorrowedAlert, animated: true, completion: nil)
                } else {
                    activityIndicator.stopAnimating()
                    loadingView.removeFromSuperview()
                    self?.rentOrReservationBook()
                }
            }
        }
    }
    
    func rentOrReservationBook() {
        let loadingView = UIView(frame: self.view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        loadingView.isUserInteractionEnabled = true
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballPulse, color: .white, padding: nil)
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        self.view.addSubview(loadingView)
        
        print("------------------------------------------------------------")
        print("rentOrReservation")
        let originalList = CurrentBookNumberManager.shared.getCurrentBorrowedList()
        print("Current borrowed list: \(originalList)")
        let reservationList = CurrentBookNumberManager.shared.getNextWillBorrowList()
        print("Current reservation list: \(reservationList)")
        var newList: [Int] = []
        
        // 0 <= Borrowed, (Borrowed+Reservation) < 5
        if originalList.count >= 0 && (originalList.count + reservationList.count) < 5 {
            print("originalList + ReservationList is not full")
            let selectedBookNumber = CurrentBookNumberManager.shared.getCurrentBookNumber()
            let numberForRequest: UInt64
            
            if selectedBookNumber / 20000 == 0 {
                numberForRequest = UInt64(selectedBookNumber % 10000)
            } else {
                numberForRequest = UInt64((selectedBookNumber % 20000) - 7)
            }
            
            APIManager.shared.changeCurrentAPIRequestBookID(numberForRequest)
            
            APIManager.shared.rentOrReserve { code in
                DispatchQueue.main.async {
                    if code == 0 {
                        print("APIManager.shared.rentOrReserve -->> Rent side error occured")
                        
                        let errorAlert = UIAlertController(title: "오류 발생", message: "관리자에게 문의하세요", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "확인", style: .default))
                        self.present(errorAlert, animated: true, completion: nil)
                    } else if code == 1 {
                        // Book rented
                        print("selectedBookNumber: \(CurrentBookNumberManager.shared.getCurrentBookNumber())")
                        let selectedBookIndex = AllBookList.shared.allBookList.firstIndex { $0.bookId == selectedBookNumber }
                        print("SelectedBook is: \(AllBookList.shared.allBookList[selectedBookIndex ?? 0].title)")
                        newList = originalList
                        AllBookList.shared.allBookList[selectedBookIndex ?? 0].currentStatus = .borrowed
                        print("Selected book's current status: \(AllBookList.shared.allBookList[selectedBookIndex ?? 0].currentStatus)")
                        newList.append(AllBookList.shared.allBookList[selectedBookIndex ?? 0].bookId)
                        print("NewList: \(newList)")
                        CurrentBookNumberManager.shared.writeCurrentBorrowedList(newList)
                        MyViewController.shared.reloadButtons()
                        self.configureBorrowButton(CurrentBookNumberManager.shared.getCurrentBookStatus())
                        print("------------------------------------------------------------")
                        MyViewController.shared.reloadButtons()
                        self.onDismiss?()
                        activityIndicator.stopAnimating()
                        loadingView.removeFromSuperview()
                    } else if code == 2 {
                        let originalList = CurrentBookNumberManager.shared.getNextWillBorrowList()
                        let borrowedList = CurrentBookNumberManager.shared.getCurrentBorrowedList()
                        var newList: [Int] = []
                        
                        if originalList.count >= 0 && (originalList.count + borrowedList.count) < 5 {
                            let selectedBookNumber = CurrentBookNumberManager.shared.getCurrentBookNumber()
                            let selectedBookIndex = AllBookList.shared.allBookList.firstIndex { $0.bookId == selectedBookNumber }
                            AllBookList.shared.allBookList[selectedBookIndex ?? 0].currentStatus = .booked
                            newList.append(AllBookList.shared.allBookList[selectedBookIndex ?? 0].bookId)
                            CurrentBookNumberManager.shared.writeNextWillBorrowList(newList)
                            self.configureBorrowButton(CurrentBookNumberManager.shared.getCurrentBookStatus())
                            MyViewController.shared.reloadButtons()
                            self.checkRentUserAndChangeStatus()
                            self.onDismiss?()
                            activityIndicator.stopAnimating()
                            loadingView.removeFromSuperview()
                        } else {
                            self.rentOverAlert()
                            activityIndicator.stopAnimating()
                            loadingView.removeFromSuperview()
                        }
                    }
                }
            }
        } else {
            rentOverAlert()
            activityIndicator.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
    
    func rentOverAlert() {
        let rentOver = UIAlertController(title: "대여량 초과", message: "대여/예약 포함 책은 5권까지만 대여하실 수 있습니다", preferredStyle: .alert)
        rentOver.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(rentOver, animated: true, completion: nil)
    }
    
    func returnBook() {
        let loadingView = UIView(frame: self.view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        loadingView.isUserInteractionEnabled = true
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballPulse, color: .white, padding: nil)
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        self.view.addSubview(loadingView)
        
        let selectedBookNumber = CurrentBookNumberManager.shared.getCurrentBookNumber()
        let numberForRequest: UInt64
        
        if selectedBookNumber / 20000 == 0 {
            numberForRequest = UInt64(selectedBookNumber % 10000)
        } else {
            numberForRequest = UInt64((selectedBookNumber % 20000) - 7)
        }
        
        APIManager.shared.changeCurrentAPIRequestBookID(numberForRequest)
        
        APIManager.shared.returnBook { success in
            DispatchQueue.main.async {
                if success {
                    print("Return response -->> \(success)")
                    var borrowedList = CurrentBookNumberManager.shared.getCurrentBorrowedList()
                    let removeId = CurrentBookNumberManager.shared.getCurrentBookNumber()
                    print("removeId: \(removeId)")
                    
                    let selectedBookIndex = AllBookList.shared.allBookList.firstIndex { $0.bookId == removeId } ?? 0
                    let selectedRemoveIndex = borrowedList.firstIndex { $0 == removeId } ?? 0
                    AllBookList.shared.allBookList[selectedBookIndex].currentStatus = .normal
                    borrowedList.remove(at: selectedRemoveIndex)
                    print("returnBook: \(borrowedList)")
                    CurrentBookNumberManager.shared.writeCurrentBorrowedList(borrowedList)
                    self.configureBorrowButton(CurrentBookNumberManager.shared.getCurrentBookStatus())
                    
                    activityIndicator.stopAnimating()
                    loadingView.removeFromSuperview()
                    
                    self.onDismiss?()
                } else {
                    activityIndicator.stopAnimating()
                    loadingView.removeFromSuperview()
                    print("APIManager.shared.return -->> Return side error occured")
                    let errorAlert = UIAlertController(title: "오류 발생", message: "관리자에게 문의하세요", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func cancelReservation() {
        let loadingView = UIView(frame: self.view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        loadingView.isUserInteractionEnabled = true
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballPulse, color: .white, padding: nil)
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        self.view.addSubview(loadingView)
        
        var reservationList = CurrentBookNumberManager.shared.getNextWillBorrowList()
        
        APIManager.shared.cancelReservation { success in
            DispatchQueue.main.async {
                if success {
                    for reservation in reservationList {
                        let selectedBookIndex = AllBookList.shared.allBookList.firstIndex { $0.bookId == reservation } ?? 0
                        AllBookList.shared.allBookList[selectedBookIndex].currentStatus = .normal
                        reservationList.remove(at: selectedBookIndex)
                        print("reservationList: \(reservationList)")
                        CurrentBookNumberManager.shared.writeNextWillBorrowList(reservationList)
                        
                        activityIndicator.stopAnimating()
                        loadingView.removeFromSuperview()
                        
                        self.onDismiss?()
                    }
                } else {
                    activityIndicator.stopAnimating()
                    loadingView.removeFromSuperview()
                    
                    print("APIManager.shared.cancelReservation error occured")
                    let errorAlert = UIAlertController(title: "오류 발생", message: "관리자에게 문의하세요", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func checkRentUserAndChangeStatus() {
        let myId = APIManager.shared.getMyId()
        
        checkStatusTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            APIManager.shared.checkReservationUser { userId in
                let reservationBookList = CurrentBookNumberManager.shared.getNextWillBorrowList()
                let firstBookId = reservationBookList[0]
                let numberForRequest: UInt64
                
                if firstBookId / 20000 == 0 {
                    numberForRequest = UInt64(firstBookId % 10000)
                } else {
                    numberForRequest = UInt64((firstBookId % 20000) - 7)
                }
                
                APIManager.shared.changeCheckRentBookID(UInt64(numberForRequest))
                
                DispatchQueue.main.async {
                    if userId == myId {
                        self.changeBookToRent()
                        self.checkStatusTimer?.invalidate()
                        self.checkStatusTimer = nil
                    }
                }
            }
        }
    }
    
    func changeBookToRent() {
        let originalList = CurrentBookNumberManager.shared.getCurrentBorrowedList()
        var reservationBookList = CurrentBookNumberManager.shared.getNextWillBorrowList()
        let firstBookId = reservationBookList[0]
        var newList: [Int] = []
        
        let selectedBookIndex = AllBookList.shared.allBookList.firstIndex { $0.bookId == firstBookId }
        print("SelectedBook is: \(AllBookList.shared.allBookList[selectedBookIndex ?? 0].title)")
        newList = originalList
        AllBookList.shared.allBookList[selectedBookIndex ?? 0].currentStatus = .borrowed
        print("Selected book's current status: \(AllBookList.shared.allBookList[selectedBookIndex ?? 0].currentStatus)")
        newList.append(AllBookList.shared.allBookList[selectedBookIndex ?? 0].bookId)
        print("NewList: \(newList)")
        reservationBookList.removeAll()
        print("ReservationBookList --> \(reservationBookList)")
        CurrentBookNumberManager.shared.writeCurrentBorrowedList(newList)
        MyViewController.shared.reloadButtons()
        self.configureBorrowButton(CurrentBookNumberManager.shared.getCurrentBookStatus())
        
        let newReservationList: [Int] = []
        CurrentBookNumberManager.shared.writeNextWillBorrowList(newReservationList)
        self.configureBorrowButton(CurrentBookNumberManager.shared.getCurrentBookStatus())
        print("------------------------------------------------------------")
        MyViewController.shared.reloadButtons()
        self.onDismiss?()
    }
    
//    func reservationBook() {
//        let originalList = CurrentBookNumberManager.shared.getNextWillBorrowList()
//        let borrowedList = CurrentBookNumberManager.shared.getCurrentBorrowedList()
//        var newList: [Int] = []
//        
//        if originalList.count >= 0 && (originalList.count + borrowedList.count) < 5 {
//            let selectedBookNumber = CurrentBookNumberManager.shared.getCurrentBookNumber()
//            let selectedBookIndex = AllBookList.shared.allBookList.firstIndex { $0.bookId == selectedBookNumber }
//            AllBookList.shared.allBookList[selectedBookIndex ?? 0].currentStatus = .booked
//            newList.append(AllBookList.shared.allBookList[selectedBookIndex ?? 0].bookId)
//            CurrentBookNumberManager.shared.writeNextWillBorrowList(newList)
//            configureBorrowButton(CurrentBookNumberManager.shared.getCurrentBookStatus())
//            MyViewController.shared.reloadButtons()
//        } else {
//            rentOverAlert()
//        }
//    }
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
