//
//  MenuViewController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class MenuViewController: UIViewController {
    
    let menuView = MenuView()
    var userTimer: Timer?
    var elapsedTime: TimeInterval = 0
    var estimatedRate: Int = 2000

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.selectedIndex = 2
        configureLayout()
    }
}

// MARK: - Layout
extension MenuViewController {
    private func configureLayout() {
        self.title = "메뉴"
        
        view.addSubview(menuView)
        
        menuView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        setComponents()
        setToday()
        menuView.logOutButton.addTarget(self, action: #selector(logOutButtonClicked), for: .touchUpInside)
    }
}

extension MenuViewController {
    private func setComponents() {
        self.menuView.price.text = String(self.estimatedRate) + "원"
        // If the timer running, stop timer
        if let timer = userTimer {
            timer.invalidate()
            userTimer = nil
            elapsedTime = 0
            
            menuView.usedTime.text = "00시간 00분 00초"
        } else {
            // Start the timer with 1.0 timeInterval
            userTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
                self?.elapsedTime += timer.timeInterval
                
                let seconds = Int(self?.elapsedTime ?? 0) % 60
                let minutes = Int(self?.elapsedTime ?? 0) / 60 % 60
                let hours = Int(self?.elapsedTime ?? 0) / 60 / 60
                
                if seconds == 1 {
                    self?.estimatedRate += 200
                    self?.menuView.price.text = String(self?.estimatedRate ?? 0) + "원"
                }
                
                self?.menuView.usedTime.text = String(format: "%02d시간 %02d분 %02d초", hours, minutes, seconds)
            })
        }
    }
    
    func setToday() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        menuView.todayDate.text = dateFormatter.string(from: today)
    }
}

extension MenuViewController {
    @objc private func logOutButtonClicked() {
        let logOutAlert = UIAlertController(title: "로그아웃하시겠습니까?", message: "로그아웃을 하시려면 '확인'를 눌러주세요", preferredStyle: .alert)
        logOutAlert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { action in
            self.feeCheck()
        }))
        logOutAlert.addAction(UIAlertAction(title: "취소", style: .default))
        
        self.present(logOutAlert, animated: true, completion: nil)
    }
    
    private func feeCheck() {
        let loadingView = UIView(frame: self.view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        loadingView.isUserInteractionEnabled = true
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballPulse, color: .white, padding: nil)
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        self.view.addSubview(loadingView)
        
        let feeMessage = String(self.estimatedRate) + "원입니다"
        let feeAlert = UIAlertController(title: "사용금액", message: feeMessage, preferredStyle: .alert)
        feeAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            APIManager.shared.logout { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        activityIndicator.stopAnimating()
                        loadingView.removeFromSuperview()
                        
                        self?.logOut()
                    } else {
                        activityIndicator.stopAnimating()
                        loadingView.removeFromSuperview()
                        
                        let cannotLogoutAlert = UIAlertController(title: "로그아웃 실패", message: "관리자에게 문의해주세요", preferredStyle: .alert)
                        cannotLogoutAlert.addAction(UIAlertAction(title: "확인", style: .default))
                        self?.present(cannotLogoutAlert, animated: true, completion: nil)
                        return
                    }
                }
            }
        }))
        self.present(feeAlert, animated: true, completion: nil)
    }
    
    private func logOut() {
        let loginViewController = LoginViewController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = loginViewController
            }
        }
    }
}
