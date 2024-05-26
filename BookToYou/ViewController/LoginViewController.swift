//
//  LoginViewController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/29/24.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    let loginTextField: UITextField = UITextField()
    let loginButton: UIButton = UIButton()
    let helloImage: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

extension LoginViewController {
    private func configure() {
        view.backgroundColor = .white
        
        let components = [loginTextField, loginButton, helloImage]
        components.forEach { component in
            view.addSubview(component)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginTextField.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
            helloImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(loginTextField.snp.top).offset(-20)
            make.width.height.equalTo(view.snp.width).multipliedBy(0.2)
        }
        
        loginTextField.clipsToBounds = true
        loginTextField.backgroundColor = .white
        loginTextField.layer.cornerRadius = 15
        loginTextField.layer.borderWidth = 1.0
        loginTextField.layer.borderColor = UIColor.lightGray.cgColor
        loginTextField.layer.shadowOpacity = 1
        loginTextField.layer.shadowRadius = 0.5
        loginTextField.layer.shadowColor = UIColor.black.cgColor
        
        loginTextField.placeholder = "로그인 코드를 입력해주세요"
        loginTextField.textColor = .black
        loginTextField.textAlignment = .center
        
        loginButton.isHidden = false
        loginButton.layer.cornerRadius = 13
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitle("로그인", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.tintColor = .systemBlue
        
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
        helloImage.image = UIImage(named: "Hello")
    }
}

extension LoginViewController {
    @objc private func loginButtonClicked() {
        guard let loginCode = loginTextField.text, loginCode == "0101" else {
            let notCorrectLoginIDAlert = UIAlertController(title: "코드가 틀립니다", message: "지정된 코드가 아닙니다.\n다시 입력해주세요", preferredStyle: .alert)
            notCorrectLoginIDAlert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(notCorrectLoginIDAlert, animated: true, completion: nil)
            return
        }
        
        let loadingView = UIView(frame: self.view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        loadingView.isUserInteractionEnabled = true
         
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballPulse, color: .white, padding: nil)
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        self.view.addSubview(loadingView)
        
        APIManager.shared.login { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    activityIndicator.stopAnimating()
                    loadingView.removeFromSuperview()
                    
                    let mainViewController = BTYTabBarController()
                    mainViewController.modalPresentationStyle = .overFullScreen
                    self?.present(mainViewController, animated: true, completion: nil)
                } else {
                    activityIndicator.stopAnimating()
                    loadingView.removeFromSuperview()
                    
                    let notCorrectLoginIDAlert = UIAlertController(title: "로그인 실패", message: "다시 시도해주세요", preferredStyle: .alert)
                    notCorrectLoginIDAlert.addAction(UIAlertAction(title: "확인", style: .default))
                    self?.present(notCorrectLoginIDAlert, animated: true, completion: nil)
                    return
                }
            }
        }
    }
}
