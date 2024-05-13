//
//  DetailOrderViewController.swift
//  BookToYou
//
//  Created by ROLF J. on 4/25/24.
//

import UIKit
import SnapKit

class DetailOrderViewController: UIViewController {
    
    let detailView: DetailOrderView = DetailOrderView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        setComponents()
    }
}

extension DetailOrderViewController {
    private func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DetailOrderViewController {
    private func setComponents() {
        let currentStuffInfo = stuffs[OrderStuffNumberManager.shared.getOrderStuffNumber()]
        
        detailView.stuffImageView.image = UIImage(named: currentStuffInfo.stuffName)
        detailView.stuffTitle.text = currentStuffInfo.title
        detailView.price.text = String(Int(currentStuffInfo.price)) + "원"
        
        detailView.buyButton.addTarget(self, action: #selector(buyButtonClicked), for: .touchUpInside)
    }
}

extension DetailOrderViewController {
    @objc func buyButtonClicked() {
        let willBuy = UIAlertController(title: "구매하시겠습니까?", message: nil, preferredStyle: .alert)
        willBuy.addAction(UIAlertAction(title: "취소", style: .cancel))
        willBuy.addAction(UIAlertAction(title: "구매", style: .default))
        self.present(willBuy, animated: true, completion: nil)
    }
}
