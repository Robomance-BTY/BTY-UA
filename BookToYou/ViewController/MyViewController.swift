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
    
    var borrowedInformation1: BookInfo?
    var borrowedInformation2: BookInfo?
    var borrowedInformation3: BookInfo?
    var reservationInformation1: BookInfo?
    var reservationInformation2: BookInfo?
    var reservationInformation3: BookInfo?
    
    let myView: MyView = MyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self
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
        myView.borrowedButton4.addTarget(self, action: #selector(borrowed4Clicked), for: .touchUpInside)
        myView.borrowedButton5.addTarget(self, action: #selector(borrowed5Clicked), for: .touchUpInside)
        myView.willBorrowButton1.addTarget(self, action: #selector(willBorrow1Clicked), for: .touchUpInside)
        myView.willBorrowButton2.addTarget(self, action: #selector(willBorrow2Clicked), for: .touchUpInside)
        myView.willBorrowButton3.addTarget(self, action: #selector(willBorrow3Clicked), for: .touchUpInside)
    }
}

extension MyViewController {
    @objc private func borrowed1Clicked() {
        print("Borrowed1 button clicked")
        if checkBorrowedBookExisted(0) == true {
            moveToDetailView(0)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func borrowed2Clicked() {
        print("Borrowed2 button clicked")
        if checkBorrowedBookExisted(1) == true {
            moveToDetailView(1)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func borrowed3Clicked() {
        print("Borrowed3 button clicked")
        if checkBorrowedBookExisted(2) == true {
            moveToDetailView(2)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func borrowed4Clicked() {
        print("Borrowed4 button clicked")
        if checkBorrowedBookExisted(3) == true {
            moveToDetailView(3)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func borrowed5Clicked() {
        print("Borrowed5 button clicked")
        if checkBorrowedBookExisted(4) == true {
            moveToDetailView(4)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func willBorrow1Clicked() {
        print("Will borrow1 button clicked")
        if checkWillBorrowBookExisted(0) == true {
            moveToDetailView(5)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func willBorrow2Clicked() {
        print("Will borrow2 button clicked")
        if checkWillBorrowBookExisted(1) == true {
            moveToDetailView(6)
        } else {
            moveToHomeView()
        }
    }
    
    @objc private func willBorrow3Clicked() {
        print("Will borrow3 button clicked")
        if checkWillBorrowBookExisted(2) == true {
            moveToDetailView(7)
        } else {
            moveToHomeView()
        }
    }
}

extension MyViewController {
    func checkBorrowedBookExisted(_ number: Int) -> Bool {
        print("CheckBorrowedBookExisted")
        print("Selected button ->> \(number)")
        
        let currentBorrowed = CurrentBookNumberManager.shared.getCurrentBorrowedList()
        print("currentBorrowed.count: \(currentBorrowed.count)")
        if number == 0 {
            if currentBorrowed.count > 0 {
                return true
            } else {
                return false
            }
        } else if number == 1 {
            if currentBorrowed.count > 1 {
                return true
            } else {
                return false
            }
        } else if number == 2 {
            if currentBorrowed.count > 2 {
                return true
            } else {
                return false
            }
        } else if number == 3 {
            if currentBorrowed.count > 3 {
                return true
            } else {
                return false
            }
        } else if number == 4 {
            if currentBorrowed.count > 4 {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    func checkWillBorrowBookExisted(_ number: Int) -> Bool {
        print("CheckWillBorrowBookExisted")
        print("Selected button ->> \(number)")
        
        let nextWillBorrow = CurrentBookNumberManager.shared.getNextWillBorrowList()
        print("currentBorrowed.count: \(nextWillBorrow.count)")
        if number == 0 {
            if nextWillBorrow.count > 0 {
                return true
            } else {
                return false
            }
        } else if number == 1 {
            if nextWillBorrow.count > 1 {
                return true
            } else {
                return false
            }
        } else if number == 2 {
            if nextWillBorrow.count > 2 {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    private func moveToHomeView() {
        print("MoveToHomeView")
        
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
        
        print("MoveToHomeViewDone")
    }
    
    private func moveToDetailView(_ number: Int) {
        print("MoveToDetailView")
        let borrowedList = CurrentBookNumberManager.shared.getCurrentBorrowedList()
        let reservationList = CurrentBookNumberManager.shared.getNextWillBorrowList()
        var selectedIndex: Int = 0
        
        switch number {
        case 0:
            selectedIndex = borrowedList[0]
        case 1:
            selectedIndex = borrowedList[1]
        case 2:
            selectedIndex = borrowedList[2]
        case 3:
            selectedIndex = borrowedList[3]
        case 4:
            selectedIndex = borrowedList[4]
        case 5:
            selectedIndex = reservationList[0]
        case 6:
            selectedIndex = reservationList[1]
        case 7:
            selectedIndex = reservationList[2]
        default:
            break
        }
        
        CurrentBookNumberManager.shared.writeCurrentBookNumber(selectedIndex)
        navigationController?.pushViewController(DetailBookViewController(), animated: true)
    }
    
    func reloadButtons() {
        print("ReloadButton")
        
        let normalIconName: String = "plusIcon"
        myView.borrowedImageView1.image = UIImage(named: normalIconName)
        myView.borrowedImageView2.image = UIImage(named: normalIconName)
        myView.borrowedImageView3.image = UIImage(named: normalIconName)
        myView.borrowedImageView4.image = UIImage(named: normalIconName)
        myView.borrowedImageView5.image = UIImage(named: normalIconName)
        myView.willBorrowImageView1.image = UIImage(named: normalIconName)
        myView.willBorrowImageView2.image = UIImage(named: normalIconName)
        myView.willBorrowImageView3.image = UIImage(named: normalIconName)
        
        let borrowedBookList = CurrentBookNumberManager.shared.getCurrentBorrowedList()
        print("Borrowed books count: \(borrowedBookList.count)")
        let nextWillBookList = CurrentBookNumberManager.shared.getNextWillBorrowList()
        print("Reservation books count: \(nextWillBookList.count)")
        
        if borrowedBookList.count == 1 {
            let index = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[0] } ?? 0
            myView.borrowedImageView1.image = UIImage(named: AllBookList.shared.allBookList[index].imageName)
        } else if borrowedBookList.count == 2 {
            let index1 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[0] } ?? 0
            let index2 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[1] } ?? 0
            myView.borrowedImageView1.image = UIImage(named: AllBookList.shared.allBookList[index1].imageName)
            myView.borrowedImageView2.image = UIImage(named: AllBookList.shared.allBookList[index2].imageName)
        } else if borrowedBookList.count == 3 {
            let index1 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[0] } ?? 0
            let index2 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[1] } ?? 0
            let index3 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[2] } ?? 0
            myView.borrowedImageView1.image = UIImage(named: AllBookList.shared.allBookList[index1].imageName)
            myView.borrowedImageView2.image = UIImage(named: AllBookList.shared.allBookList[index2].imageName)
            myView.borrowedImageView3.image = UIImage(named: AllBookList.shared.allBookList[index3].imageName)
        } else if borrowedBookList.count == 4 {
            let index1 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[0] } ?? 0
            let index2 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[1] } ?? 0
            let index3 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[2] } ?? 0
            let index4 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[3] } ?? 0
            myView.borrowedImageView1.image = UIImage(named: AllBookList.shared.allBookList[index1].imageName)
            myView.borrowedImageView2.image = UIImage(named: AllBookList.shared.allBookList[index2].imageName)
            myView.borrowedImageView3.image = UIImage(named: AllBookList.shared.allBookList[index3].imageName)
            myView.borrowedImageView4.image = UIImage(named: AllBookList.shared.allBookList[index4].imageName)
        } else if borrowedBookList.count == 5 {
            let index1 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[0] } ?? 0
            let index2 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[1] } ?? 0
            let index3 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[2] } ?? 0
            let index4 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[3] } ?? 0
            let index5 = AllBookList.shared.allBookList.firstIndex { $0.bookId == borrowedBookList[4] } ?? 0
            myView.borrowedImageView1.image = UIImage(named: AllBookList.shared.allBookList[index1].imageName)
            myView.borrowedImageView2.image = UIImage(named: AllBookList.shared.allBookList[index2].imageName)
            myView.borrowedImageView3.image = UIImage(named: AllBookList.shared.allBookList[index3].imageName)
            myView.borrowedImageView4.image = UIImage(named: AllBookList.shared.allBookList[index4].imageName)
            myView.borrowedImageView5.image = UIImage(named: AllBookList.shared.allBookList[index5].imageName)
        } else if borrowedBookList.count == 0 {
            print("No books")
        } else {
            fatalError("ReloadButton(): borrowedBookList error")
        }
        
        if nextWillBookList.count == 1 {
            let index = AllBookList.shared.allBookList.firstIndex { $0.bookId == nextWillBookList[0] } ?? 0
            myView.willBorrowImageView1.image = UIImage(named: AllBookList.shared.allBookList[index].imageName)
        } else if nextWillBookList.count == 2 {
            let index1 = AllBookList.shared.allBookList.firstIndex { $0.bookId == nextWillBookList[0] } ?? 0
            let index2 = AllBookList.shared.allBookList.firstIndex { $0.bookId == nextWillBookList[1] } ?? 0
            myView.willBorrowImageView1.image = UIImage(named: AllBookList.shared.allBookList[index1].imageName)
            myView.willBorrowImageView2.image = UIImage(named: AllBookList.shared.allBookList[index2].imageName)
        } else if nextWillBookList.count == 3 {
            let index1 = AllBookList.shared.allBookList.firstIndex { $0.bookId == nextWillBookList[0] } ?? 0
            let index2 = AllBookList.shared.allBookList.firstIndex { $0.bookId == nextWillBookList[1] } ?? 0
            let index3 = AllBookList.shared.allBookList.firstIndex { $0.bookId == nextWillBookList[2] } ?? 0
            myView.willBorrowImageView1.image = UIImage(named: AllBookList.shared.allBookList[index1].imageName)
            myView.willBorrowImageView2.image = UIImage(named: AllBookList.shared.allBookList[index2].imageName)
            myView.willBorrowImageView3.image = UIImage(named: AllBookList.shared.allBookList[index3].imageName)
        } else if nextWillBookList.count == 0 {
            print("No reservations")
        } else {
            fatalError("ReloadButton(): nextWillBookList error")
        }
    }
}

extension MyViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let detailViewController = viewController as? DetailBookViewController {
            detailViewController.onDismiss = { [weak self] in
                self?.reloadButtons()
            }
        }
    }
}
