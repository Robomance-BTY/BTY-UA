//
//  CurrentBookNumberManager.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import Foundation

public enum BookStatus {
    case normal
    case borrowed
    case booked
}

class CurrentBookNumberManager {
    static let shared = CurrentBookNumberManager()
    
    private var currentBorrowedList: [Int] = []
    private var nextWillBorrowList: [Int] = []
    
    private let apricotList = Array(10001...10005)
    private let onlyLevelUpList = Array(10006...10015)
    private let personalPOVList = Array(10016...10025)
    private let correctRomanceList = Array(10026...10036)
    private let oneSeoncdList = Array(10037...10052)
    private let attackOnTitanList = Array(20001...20034)
    private let curseTurnList = Array(20035...20059)
    
    private var number = Int()
    private var series = Int()
    
    public func getCurrentBookNumber() -> Int {
        return number
    }
    
    public func getCurrentBookInformation() -> BookInfo {
        print("------------------------------------------------------------")
        print("number: \(number)")
        print("GetCurrentNumber: \(getCurrentBookNumber())")
        let bookInfo = AllBookList.shared.allBookList.first { $0.bookId == getCurrentBookNumber() }
        print("GetCurrentBookInformation: \(String(describing: bookInfo))")
        print("------------------------------------------------------------")
        return bookInfo ?? BookInfo(bookId: 0, imageName: "", title: "", author: "", genre: "", country: "", description: "", published: "", currentStatus: BookStatus.normal)
    }
    
    public func getCurrentBookStatus() -> BookStatus {
        let current = AllBookList.shared.allBookList.first { $0.bookId == getCurrentBookNumber() }?.currentStatus
        return current ?? .normal
    }
    
    public func writeCurrentBookNumber(_ writing: Int) {
        let toFindNumber = writing
        if let index = AllBookList.shared.allBookList.firstIndex(where: { $0.bookId == toFindNumber }) {
            self.number = AllBookList.shared.allBookList[index].bookId
        } else {
            fatalError("This book's index doesn't existed")
        }
        
        if apricotList.contains(toFindNumber) {
            series = 0
        } else if onlyLevelUpList.contains(toFindNumber) {
            series = 1
        } else if personalPOVList.contains(toFindNumber) {
            series = 2
        } else if correctRomanceList.contains(toFindNumber) {
            series = 3
        } else if oneSeoncdList.contains(toFindNumber) {
            series = 4
        } else if attackOnTitanList.contains(toFindNumber) {
            series = 5
        } else if curseTurnList.contains(toFindNumber) {
            series = 6
        }
    }
    
    public func getSeriesNumbers() -> [Int] {
        switch series {
        case 0:
            return apricotList
        case 1:
            return onlyLevelUpList
        case 2:
            return personalPOVList
        case 3:
            return correctRomanceList
        case 4:
            return oneSeoncdList
        case 5:
            return attackOnTitanList
        case 6:
            return curseTurnList
        default:
            fatalError()
        }
    }
    
    public func getSeries() -> [BookInfo] {
        let currentSeriesNumbers = getSeriesNumbers()
        let seriesBooks = AllBookList.shared.allBookList.filter { bookInfo in
            currentSeriesNumbers.contains(Int(bookInfo.bookId))
        }
        
        return seriesBooks
    }
    
    public func getCurrentBorrowedList() -> [Int] {
        return currentBorrowedList
    }
    
    public func writeCurrentBorrowedList(_ list: [Int]) {
        currentBorrowedList.removeAll()
        currentBorrowedList = list
    }
    
    public func getNextWillBorrowList() -> [Int] {
        return nextWillBorrowList
    }
    
    public func writeNextWillBorrowList(_ list: [Int]) {
        nextWillBorrowList.removeAll()
        nextWillBorrowList = list
    }
}
