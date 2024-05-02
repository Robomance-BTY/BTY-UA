//
//  OrderStuffNumberManager.swift
//  BookToYou
//
//  Created by ROLF J. on 4/25/24.
//

import Foundation

class OrderStuffNumberManager {
    static let shared = OrderStuffNumberManager()
    
    private var number = Int()
    
    public func getOrderStuffNumber() -> Int {
        return number
    }
    
    public func writeOrderStuffNumber(_ writing: Int) {
        let toFindNumber = writing
        if let index = stuffs.firstIndex(where: { $0.orderId == toFindNumber }) {
            self.number = index
        } else {
            fatalError("This book's index doesn't existed")
        }
    }
}
