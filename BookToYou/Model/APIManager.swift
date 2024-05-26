//
//  APIManager.swift
//  BookToYou
//
//  Created by ROLF J. on 5/13/24.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
    public func changeCurrentAPIRequestBookID(_ bookId: UInt64) {
        currentBookId = bookId
    }
    
    public func changeCheckRentBookID(_ bookId: UInt64) {
        checkRentBookId = bookId
    }
    
    private var checkRentBookId: UInt64 = 1
    private let currentId: UInt64 = 1
    private var currentBookId: UInt64 = 1
    
    public func getMyId() -> Int {
        return Int(currentId)
    }
    
    struct LoginResponse: Codable {
        let id: UInt64
        let loginCode: String
        let loginState: Bool
        let loginTime: String
        let usedTimeInSeconds: String?
        let usageFee: String?
    }
    
    public func login(completion: @escaping((Bool) -> Void)) {
        let parameters = [
            "loginCode": "Table\(currentId)"
        ]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error in creating JSON of login")
            return
        }

        var request = URLRequest(url: URL(string: "http://192.168.1.235:8082/application/login")!, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let decoder = JSONDecoder()
                        let decodedLogin = try decoder.decode(LoginResponse.self, from: data)
                        print(decodedLogin)
                        completion(true)
                    } catch {
                        print("Login decoder error")
                        print(error)
                        completion(false)
                    }
                case 404:
                    print("Login 404 error")
                    completion(false)
                default:
                    print("Login switch error")
                    completion(false)
                }
            }
        }

        task.resume()
    }
    
    struct UsedTime: Codable {
        let usedTime: UInt64
    }
    
    public func usedTime(completion: @escaping((UInt64) -> Void)) {
        let parameters = [
            "id":currentId
        ]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error in creating JSON in usedTime")
            return
        }

        var request = URLRequest(url: URL(string: "http://192.168.1.235:8082/application/usedTime")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                DispatchQueue.main.async {
                    completion(0)
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let decoder = JSONDecoder()
                        let usedTimeResponse = try decoder.decode(UsedTime.self, from: data)
                        print("usedTime: \(String(Int(usedTimeResponse.usedTime)))")
                        DispatchQueue.main.async  {
                            completion(usedTimeResponse.usedTime)
                        }
                    } catch {
                        print("UsedTime decoder error")
                        print(error)
                        DispatchQueue.main.async {
                            completion(0)
                        }
                    }
                case 404:
                    print("UsedTime 404 error")
                    DispatchQueue.main.async {
                        completion(0)
                    }
                default:
                    print("Received HTTP \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        completion(0)
                    }
                }
            } else {
                print("UsedTime switch error")
            }
        }

        task.resume()
    }
    
    struct RentOrReserve: Codable {
        let message: String
        let locationInfo: String
    }

    public func rentOrReserve(completion: @escaping((Int) -> Void)) {
        let parameters = [
            "userId":currentId,
            "bookId":currentBookId
        ]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error in creating JSON in RentOrReserve")
            return
        }

        var request = URLRequest(url: URL(string: "http://192.168.1.235:8082/application/api/rentOrReserve")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(0)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let decoder = JSONDecoder()
                        let rentOrReserveResponse = try decoder.decode(RentOrReserve.self, from: data)
                        print(rentOrReserveResponse)
                        
                        if rentOrReserveResponse.message == "책이 성공적으로 대여되었습니다." {
                            completion(1)
                        } else if rentOrReserveResponse.message == "책이 이미 대여 중이므로 예약되었습니다. 예약된 책이 반납되어 배송됩니다." {
                            completion(2)
                        }
                    } catch {
                        print("RentOrReserve decoder error")
                        print(error)
                        completion(0)
                    }
                case 404:
                    print("RentOrReserve 404 error")
                    completion(0)
                case 500:
                    print("RentOrReserve 500 error")
                    completion(0)
                default:
                    print("RentOrReserve Received HTTP \(httpResponse.statusCode)")
                    completion(0)
                }
            } else {
                print("RentOrReserve switch error")
            }
        }

        task.resume()
    }
    
    struct ReturnBook: Codable {
        let message: String
        let userId: UInt64
    }

    public func returnBook(completion: @escaping((Bool) -> Void)) {
        let parameters = [
            "userId":currentId,
            "bookId":currentBookId
        ]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error in creating JSON in ReturnBook")
            return
        }

        var request = URLRequest(url: URL(string: "http://192.168.1.235:8082/application/api/return")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        print("Before decoding")
                        let decoder = JSONDecoder()
                        let returnBook = try decoder.decode(ReturnBook.self, from: data)
                        print(returnBook)
                        completion(true)
                    } catch {
                        print("Return decoder error")
                        print(error)
                        completion(false)
                    }
                case 400:
                    print("Return 400 error")
                    completion(false)
                case 404:
                    print("Return 404 error")
                    completion(false)
                default:
                    print("Return switch error")
                    completion(false)
                }
            }
        }

        task.resume()
    }
    
    struct RentList: Codable {
        let id: Int
        let usedId: Int
        let bookId: Int
        let rentalTime: Date
        let returnTime: Date
        let rentalState: Bool
    }

    public func rentList() {
        let parameters = [
            "userId":currentId
        ]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error in creating JSON in RentList")
            return
        }

        var request = URLRequest(url: URL(string: "http://192.168.1.235:8082/application/api/list/1")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let decoder = JSONDecoder()
                        let rentList = try decoder.decode(RentList.self, from: data)
                        print(rentList)
                    } catch {
                        print("RentList decoder error")
                    }
                case 404:
                    print("RentList 404 error")
                default:
                    print("RentList switch error")
                }
            }
        }

        task.resume()
    }
    
    struct LogoutUserEntity: Codable {
        let id: UInt64
        let loginCode: String
        let loginState: Bool
        let loginTime: Date
        let usedTimeInSeconds: UInt64
        let usageFee: UInt64
    }
    
    struct Logout: Codable {
        let usedTime: UInt64
        let logoutResult: LogoutUserEntity
    }

    public func logout(completion: @escaping((Bool) -> Void)) {
        let parameters = [
            "id":currentId
        ]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error in creating JSON in usedTime")
            return
        }

        var request = URLRequest(url: URL(string: "http://192.168.1.235:8082/application/logout")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print(String(data: data, encoding: .utf8)!)
                    completion(true)
                case 404:
                    print("Logout 404 error")
                    completion(false)
                default:
                    print("Logout switch error")
                    completion(false)
                }
                
            }
        }

        task.resume()
    }

    public func order() {
        let parameters = "{\n    \"userId\":\(currentId),\n    \"productId\":1\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://192.168.1.235:8082/application/order")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }
    
    public func methodForReserve(completion: @escaping((Bool) -> Void)) {
        let parameters = [
            "bookId":currentBookId
        ]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error in creating JSON in MethodForReserve")
            return
        }

        var request = URLRequest(url: URL(string: "http://192.168.1.235:8082/application/api/testMethodForReserve")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    let responseString = String(data: data, encoding: .utf8)
                    if let boolValue = Bool(responseString ?? "") {
                        completion(boolValue)
                    } else {
                        print("Failed to get methodForReserve")
                        completion(false)
                    }
                case 404:
                    print("MethodForReserve 404 error")
                    completion(false)
                default:
                    print("Received HTTP \(httpResponse.statusCode)")
                    completion(false)
                }
            } else {
                print("MethodForReserve switch error")
                completion(false)
            }
        }

        task.resume()
    }

    public func methodForReturn(completion: @escaping((Bool) -> Void)) {
        let parameters = [
            "bookId":currentBookId
        ]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error in creating JSON in MethodForReturn")
            return
        }

        var request = URLRequest(url: URL(string: "http://192.168.1.235:8082/application/api/testMethodForReturn")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    let responseString = String(data: data, encoding: .utf8)
                    if let boolValue = Bool(responseString ?? "") {
                        completion(boolValue)
                    } else {
                        print("Failed to get methodForReturn")
                        completion(false)
                    }
                case 404:
                    print("MethodForReturn 404 error")
                    completion(false)
                default:
                    print("Received HTTP \(httpResponse.statusCode)")
                    completion(false)
                }
            } else {
                print("MethodForReturn switch error")
                completion(false)
            }
        }

        task.resume()
    }
    
    struct FirstReservation: Codable {
        let id: UInt64
        let usedId: UInt64
        let bookId: UInt64
        let reservationTime: Date
    }
    
    struct CancelReservation: Codable {
        let firstReservation: FirstReservation
        let rented: Bool
    }

    public func cancelReservation(completion: @escaping((Bool) -> Void)) {
        let parameters = [
            "userId":currentId
        ]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error in creating JSON in CancelReservation")
            return
        }

        var request = URLRequest(url: URL(string: "http://192.168.1.235:8082/application/api/cancelReserve")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let decoder = JSONDecoder()
                        let cancelReservation = try decoder.decode(CancelReservation.self, from: data)
                        print(cancelReservation)
                        completion(true)
                    } catch {
                        print("Cancel decoder error")
                        print(error)
                        completion(false)
                    }
                case 404:
                    print("CancelReservation 404 error")
                    completion(false)
                default:
                    print("CancelReservation default error")
                    completion(false)
                }
            }
        }

        task.resume()
    }
    
    struct CheckRentBook: Codable {
        let userId: UInt64
    }
    
    public func checkReservationUser(completion: @escaping((Int) -> Void)) {
        let parameters = [
            "bookId":checkRentBookId
        ]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error in creating JOSN in CheckReservationUser")
            return
        }

        var request = URLRequest(url: URL(string: "http://192.168.1.235:8082/application/api/users-by-book")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let decoder = JSONDecoder()
                        let checkRentUser = try? decoder.decode(CheckRentBook.self, from: data)
                        print(checkRentUser?.userId ?? 0)
                        completion(Int(checkRentUser?.userId ?? 0))
                    }
                case 404:
                    print("CheckReservationUser 404 error")
                    completion(0)
                default:
                    print("CheckReservationUser default error")
                    completion(0)
                }
            }
        }

        task.resume()
    }
}
