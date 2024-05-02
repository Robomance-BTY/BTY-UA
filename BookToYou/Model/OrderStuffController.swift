//
//  OrderStuffController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/25/24.
//

import Foundation

struct OrderInfo: Hashable {
    var orderId: UInt64
    var stuffName: String
    var title: String
    var price: Float
}

struct OrderInfoCollection: Hashable {
    var stuffsTitle: String
    var stuffs: [OrderInfo]
}

class OrderStuffController {
    
    struct OrderInfo: Hashable {
        var orderId: UInt64
        var stuffName: String
        var title: String
        var price: Float
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

    struct OrderInfoCollection: Hashable {
        var stuffsTitle: String
        var stuffs: [OrderInfo]
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

    var collections: [OrderInfoCollection] {
        return _collections
    }
    
    init() {
        generateOrderCollections()
    }
    fileprivate var _collections = [OrderInfoCollection]()
}

extension OrderStuffController {
    func generateOrderCollections() {
        _collections = [
            OrderInfoCollection(stuffsTitle: "🍜 라면류", stuffs: [OrderInfo(orderId: 1001, stuffName: "신라면", title: "신라면", price: 3000.0), OrderInfo(orderId: 1002, stuffName: "너구리", title: "너구리", price: 3000.0), OrderInfo(orderId: 1003, stuffName: "사리곰탕", title: "사리곰탕", price: 3000.0), OrderInfo(orderId: 1004, stuffName: "열라면", title: "열라면", price: 3000.0), OrderInfo(orderId: 1005, stuffName: "진라면", title: "진라면", price: 3000.0), OrderInfo(orderId: 1006, stuffName: "짜파게티", title: "짜파게티", price: 3000.0)]),
            OrderInfoCollection(stuffsTitle: "🧃 음료류", stuffs: [OrderInfo(orderId: 2001, stuffName: "라떼", title: "라떼", price: 2000.0), OrderInfo(orderId: 2002, stuffName: "스프라이트", title: "스프라이트", price: 2000.0), OrderInfo(orderId: 2003, stuffName: "보성말차", title: "보성말차", price: 2000.0), OrderInfo(orderId: 2004, stuffName: "아메리카노", title: "아메리카노", price: 2000.0), OrderInfo(orderId: 2005, stuffName: "제로펩시", title: "제로펩시", price: 2000.0), OrderInfo(orderId: 2006, stuffName: "코카콜라", title: "코카콜라", price: 2000.0)]),
            OrderInfoCollection(stuffsTitle: "🍛 조리식품류", stuffs: [OrderInfo(orderId: 3001, stuffName: "가라아게", title: "가라아게", price: 5000.0), OrderInfo(orderId: 3002, stuffName: "김치볶음밥", title: "김치볶음밥", price: 6000.0), OrderInfo(orderId: 3003, stuffName: "돈까스마요덮밥", title: "돈까스마요덮밥", price: 7000.0), OrderInfo(orderId: 3004, stuffName: "소떡소떡", title: "소떡소떡", price: 3000.0), OrderInfo(orderId: 3005, stuffName: "제육볶음", title: "제육볶음", price: 6000.0), OrderInfo(orderId: 3006, stuffName: "참치마요", title: "참치마요", price: 5000.0), OrderInfo(orderId: 3007, stuffName: "타코야끼", title: "타코야끼", price: 3000.0)])
        ]
    }
}

let stuffs: [OrderInfo] = [OrderInfo(orderId: 1001, stuffName: "신라면", title: "신라면", price: 3000.0), OrderInfo(orderId: 1002, stuffName: "너구리", title: "너구리", price: 3000.0), OrderInfo(orderId: 1003, stuffName: "사리곰탕", title: "사리곰탕", price: 3000.0), OrderInfo(orderId: 1004, stuffName: "열라면", title: "열라면", price: 3000.0), OrderInfo(orderId: 1005, stuffName: "진라면", title: "진라면", price: 3000.0), OrderInfo(orderId: 1006, stuffName: "짜파게티", title: "짜파게티", price: 3000.0), OrderInfo(orderId: 2001, stuffName: "라떼", title: "라떼", price: 2000.0), OrderInfo(orderId: 2002, stuffName: "스프라이트", title: "스프라이트", price: 2000.0), OrderInfo(orderId: 2003, stuffName: "보성말차", title: "보성말차", price: 2000.0), OrderInfo(orderId: 2004, stuffName: "아메리카노", title: "아메리카노", price: 2000.0), OrderInfo(orderId: 2005, stuffName: "제로펩시", title: "제로펩시", price: 2000.0), OrderInfo(orderId: 2006, stuffName: "코카콜라", title: "코카콜라", price: 2000.0), OrderInfo(orderId: 3001, stuffName: "가라아게", title: "가라아게", price: 5000.0), OrderInfo(orderId: 3002, stuffName: "김치볶음밥", title: "김치볶음밥", price: 6000.0), OrderInfo(orderId: 3003, stuffName: "돈까스마요덮밥", title: "돈까스마요덮밥", price: 7000.0), OrderInfo(orderId: 3004, stuffName: "소떡소떡", title: "소떡소떡", price: 3000.0), OrderInfo(orderId: 3005, stuffName: "제육볶음", title: "제육볶음", price: 6000.0), OrderInfo(orderId: 3006, stuffName: "참치마요", title: "참치마요", price: 5000.0), OrderInfo(orderId: 3007, stuffName: "타코야끼", title: "타코야끼", price: 3000.0)]
