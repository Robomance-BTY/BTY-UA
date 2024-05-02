//
//  BTYTabBarController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/16/24.
//

import UIKit

class BTYTabBarController: UITabBarController {
    static let shared = BTYTabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.delegate = self
        configureLayout()
        self.selectedIndex = 4
    }
}

extension BTYTabBarController {
    private func configureLayout() {
        view.backgroundColor = .white
        
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .lightGray
        
        let order = createNavigation("주문", UIImage(systemName: "menucard"), UIImage(systemName: "menucard.fill"), OrderViewController())
        let search = createNavigation("검색", UIImage(systemName: "magnifyingglass.circle"), UIImage(systemName: "magnifyingglass.circle.fill"), SearchViewController())
        let home = createNavigation("홈", UIImage(systemName: "house"), UIImage(systemName: "house.fill"), HomeViewController())
        let my = createNavigation("내 서재", UIImage(systemName: "person"), UIImage(systemName: "person.fill"), MyViewController())
        let setting = createNavigation("설정", UIImage(systemName: "gearshape"), UIImage(systemName: "gearshape.fill"), MenuViewController())
        
        self.setViewControllers([order, search, home, my, setting], animated: true)
    }
    
    private func createNavigation(_ title: String, _ image: UIImage?, _ selectedImage: UIImage?, _ viewController: UIViewController) -> UINavigationController {
        
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem.title = title
        navigation.tabBarItem.image = image
        navigation.tabBarItem.selectedImage = selectedImage
        
        return navigation
    }
}

extension BTYTabBarController {
    @objc private func logOut() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BTYTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = self.viewControllers?.firstIndex(of: self), index == 4 {
//            self.navigationItem.setHidesBackButton(false, animated: true)
            self.navigationItem.setRightBarButton(UIBarButtonItem(title: "돌아가기", style: .plain, target: self, action: #selector(logOut)), animated: true)
            self.navigationItem.rightBarButtonItem?.tintColor = .systemRed
        } else {
//            self.navigationItem.setHidesBackButton(true, animated: false)
        }
    }
}
