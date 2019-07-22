//
//  ViewController.swift
//  Foodist
//
//  Created by Karim Cordilia on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let settingsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        settingsButton.backgroundColor = .white
        settingsButton.setImage(UIImage(named: "settings"), for: .normal)
        let barButton = UIBarButtonItem(customView: settingsButton)
        navigationController?.navigationItem.setLeftBarButton(barButton, animated: true)
    }
}
