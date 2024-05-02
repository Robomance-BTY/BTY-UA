//
//  CurrentBookNumberManager.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import Foundation

class CurrentBookNumberManager {
    static let shared = CurrentBookNumberManager()
    
    enum BookStatus {
        case normal
        case borrowed
        case booked
    }
    
    private var currentBorrowedList: [Int] = []
    private var nextWillBorrowList: [Int] = []
    
    private let apricotList = Array(10001...10005)
    private let onlyLevelUpList = Array(10006...10015)
    private let attackOnTitanList = Array(20001...20034)
    
    private var number = Int()
    private var series = Int()
    
    public func getCurrentBookNumber() -> Int {
        return number
    }
    
    public func getCurrentBookStatus() -> BookStatus {
        let number = getCurrentBookNumber()
        if currentBorrowedList.contains(number) {
            return BookStatus.borrowed
        } else if nextWillBorrowList.contains(number) {
            return BookStatus.booked
        } else {
            return BookStatus.normal
        }
    }
    
    public func writeCurrentBookNumber(_ writing: Int) {
        let toFindNumber = writing
        if let index = allBookList.firstIndex(where: { $0.bookId == toFindNumber }) {
            self.number = index
        } else {
            fatalError("This book's index doesn't existed")
        }
        
        if apricotList.contains(toFindNumber) {
            series = 0
        } else if onlyLevelUpList.contains(toFindNumber) {
            series = 1
        } else if attackOnTitanList.contains(toFindNumber) {
            series = 2
        }
    }
    
    public func getSeriesNumbers() -> [Int] {
        switch series {
        case 0:
            return apricotList
        case 1:
            return onlyLevelUpList
        case 2:
            return attackOnTitanList
        default:
            fatalError()
        }
    }
    
    public func getSeries() -> [BookInfo] {
        let currentSeriesNumbers = getSeriesNumbers()
        let seriesBooks = allBookList.filter { bookInfo in
            currentSeriesNumbers.contains(Int(bookInfo.bookId))
        }
        
        return seriesBooks
    }
    
    public func borrowed(_ id: Int) {
        if currentBorrowedList.contains(id) == false {
            currentBorrowedList.append(id)
        }
    }
    
    public func returnBook(_ id: Int) {
        if currentBorrowedList.contains(id) == true {
            if let index = currentBorrowedList.firstIndex(of: id) {
                currentBorrowedList.remove(at: index)
            }
        }
    }
    
    public func bookTheBook(_ id: Int) {
        if nextWillBorrowList.contains(id) == false {
            nextWillBorrowList.append(id)
        }
    }
    
    public func cancelBook(_ id: Int) {
        if nextWillBorrowList.contains(id) == true {
            if let index = nextWillBorrowList.firstIndex(of: id) {
                nextWillBorrowList.remove(at: index)
            }
        }
    }
}
