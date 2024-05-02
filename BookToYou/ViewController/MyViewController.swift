//
//  MyViewController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import UIKit
import SnapKit

class MyViewController: UIViewController {
    static let shared = MyViewController()
    
    let myView: MyView = MyView()
    
    var borrowedBooksList: [Int : BookInfo] = [:]
    var nextWillBorrowBooksList: [Int : BookInfo] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
}

// MARK: - Layout
extension MyViewController {
    private func configureLayout() {
        self.title = "내 서재"
        
        view.backgroundColor = .white
        
        let components = [myView]
        
        components.forEach { component in
            view.addSubview(component)
        }
        
        myView.snp.makeConstraints { make in
            make.center.width.height.equalTo(view.safeAreaLayoutGuide)
        }
        
        myView.borrowedButton1.addTarget(self, action: #selector(borrowed1Clicked), for: .touchUpInside)
        myView.borrowedButton2.addTarget(self, action: #selector(borrowed2Clicked), for: .touchUpInside)
        myView.borrowedButton3.addTarget(self, action: #selector(borrowed3Clicked), for: .touchUpInside)
        myView.willBorrowButton1.addTarget(self, action: #selector(willBorrow1Clicked), for: .touchUpInside)
        myView.willBorrowButton2.addTarget(self, action: #selector(willBorrow2Clicked), for: .touchUpInside)
        myView.willBorrowButton3.addTarget(self, action: #selector(willBorrow3Clicked), for: .touchUpInside)
    }
}

extension MyViewController {
    @objc private func borrowed1Clicked() {
        if checkBookExisted(0) == false {
            moveToDetailView(0)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func borrowed2Clicked() {
        if checkBookExisted(1) == false {
            moveToDetailView(1)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func borrowed3Clicked() {
        if checkBookExisted(2) == false {
            moveToDetailView(2)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func willBorrow1Clicked() {
        if checkBookExisted(3) == false {
            moveToDetailView(3)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func willBorrow2Clicked() {
        if checkBookExisted(4) == false {
            moveToDetailView(4)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func willBorrow3Clicked() {
        if checkBookExisted(5) == false {
            moveToDetailView(5)
        } else {
            moveToHomeView()
        }
    }
}

extension MyViewController {
    func checkBookExisted(_ number: Int) -> Bool {
        switch(number) {
        case 0:
            return borrowedBooksList.keys.isEmpty
        case 1:
            return borrowedBooksList.keys.isEmpty
        case 2:
            return borrowedBooksList.keys.isEmpty
        case 3:
            return nextWillBorrowBooksList.keys.isEmpty
        case 4:
            return nextWillBorrowBooksList.keys.isEmpty
        case 5:
            return nextWillBorrowBooksList.keys.isEmpty
        default:
            break
        }
        
        return false
    }
    
    func getBookInfoAndApplication(_ id: Int) {
        if borrowedBooksList.count == 3 {
            let fullAlert = UIAlertController(title: "대여량 초과", message: "책은 3권까지 대여할 수 있습니다", preferredStyle: .alert)
            fullAlert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(fullAlert, animated: true, completion: nil)
            return
        }
        
        if let index = allBookList.first(where: { $0.bookId == id }) {
            let indexCheck = borrowedBooksList.values
            if indexCheck.contains(index) {
                let bookAlert = UIAlertController(title: "대여 중인 책입니다", message: "책을 예약하시겠습니까?", preferredStyle: .alert)
                bookAlert.addAction(UIAlertAction(title: "대여", style: .default, handler: { [weak self] _ in
                    guard self != nil else { return }
                    self?.getBookInfoAndReservation(index)
                }))
                bookAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
                self.present(bookAlert, animated: true, completion: nil)
            }
        }
        
        if let index = allBookList.first(where: { $0.bookId == id }) {
            self.myView.borrowedImageView1.image = UIImage(named: index.imageName)
            borrowedBooksList[borrowedBooksList.count] = index
            print("Borrowed List : \(borrowedBooksList)")
        } else {
            fatalError("This book's index doesn't existed")
        }
    }
    
    
    func getBookInfoAndReservation(_ bookInfo: BookInfo) {
        if nextWillBorrowBooksList.count == 3 {
            let fullAlert = UIAlertController(title: "예약량 초과", message: "책은 3권까지 예약할 수 있습니다", preferredStyle: .alert)
            fullAlert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(fullAlert, animated: true, completion: nil)
            return
        }
        
        self.myView.willBorrowImageView1.image = UIImage(named: bookInfo.imageName)
        nextWillBorrowBooksList[nextWillBorrowBooksList.count] = bookInfo
        print("Reservation List : \(nextWillBorrowBooksList)")
    }
    
    func returnBook(_ id: Int) {
        if let indexToRemove = borrowedBooksList.values.firstIndex(where: { $0.bookId == id }) {
            borrowedBooksList.remove(at: indexToRemove)
            
            if borrowedBooksList.count != 0 {
                var newIndex = 0
                var newBorrowedBooksList: [Int : BookInfo] = [:]
                for (_, value) in borrowedBooksList {
                    newBorrowedBooksList[newIndex] = value
                    newIndex += 1
                }
            }
        } else {
            fatalError()
        }
    }
    
    func bookCancel(_ id: Int) {
        if let indexToCancel = nextWillBorrowBooksList.values.firstIndex(where: { $0.bookId == id }) {
            nextWillBorrowBooksList.remove(at: indexToCancel)
            
            if nextWillBorrowBooksList.count != 0 {
                var newIndex = 0
                var newNextWillBorrowBooksList: [ Int : BookInfo ] = [:]
                for (_, value) in nextWillBorrowBooksList {
                    newNextWillBorrowBooksList[newIndex] = value
                    newIndex += 1
                }
            }
        } else {
            fatalError()
        }
    }
    
    func reloadDataAndImages() {
        self.myView.borrowedImageView1.image = nil
        self.myView.borrowedImageView2.image = nil
        self.myView.borrowedImageView3.image = nil
        self.myView.willBorrowImageView1.image = nil
        self.myView.willBorrowImageView2.image = nil
        self.myView.willBorrowImageView3.image = nil
        
        if borrowedBooksList.count > 0 {
            for (key, value) in borrowedBooksList {
                if key == 0 {
                    self.myView.borrowedImageView1.image = UIImage(named: value.imageName)
                } else  if key == 1 {
                    self.myView.borrowedImageView2.image = UIImage(named: value.imageName)
                }
            }
        }
    }
    
    func whatBookInList(_ number: Int) -> Int {
        var selectedBookId: Int
        switch(number) {
        case 0, 1, 2:
            selectedBookId = borrowedBooksList[number]?.bookId ?? 0
        case 3, 4, 5:
            selectedBookId = nextWillBorrowBooksList[number]?.bookId ?? 0
        default:
            return 0
        }
        return selectedBookId
    }
    
    private func moveToHomeView() {
        if let tabBarController = self.tabBarController as? BTYTabBarController {
            if let homeViewController = tabBarController.viewControllers?.first(where: { $0 is HomeViewController }) {
                tabBarController.selectedViewController = homeViewController
            }
        }
    }
    
    private func moveToDetailView(_ number: Int) {
        if let bookInfo = borrowedBooksList[number] {
            let currentNumber = bookInfo.bookId
            CurrentBookNumberManager.shared.writeCurrentBookNumber(currentNumber)
        }
        
        let bookDetailViewController = DetailBookViewController()
        navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
}
