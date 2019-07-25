//
//  ViewController.swift
//  Foodist
//
//  Created by Karim Cordilia on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var preferences: [Preference] = []
    var pageViewPreference: String = "dessert"

    //TODO: - chnage variable name preferences
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchPreference()
    }

    func setUpNavigationBar() {
        navigationItem.title = "Foodist"
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settingsTapped))
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }

    @objc func settingsTapped() {
        performSegue(withIdentifier: "showPreference", sender: self)
    }

    fileprivate func fetchPreference() {
        if let savedPreference = UserDefaults.standard.object(forKey: "UserPreference") as? Data {
            let decoder = JSONDecoder()
            do {
               let savedPreference = try decoder.decode([Preference].self, from: savedPreference)
                preferences = savedPreference
            } catch let error {
                print("error in decoding preference ",error)
                return
            }
        } else {
            let mainCourse = PreferenceOption(name: "main+course", displayTitle: "Main course")
            let dessert = PreferenceOption(name: "dessert", displayTitle: "Dessert")
            let italian = PreferenceOption(name: "italian", displayTitle: "Italian")
            let breakfast = PreferenceOption(name: "breakfast", displayTitle: "Breakfast")
            let defaultPreference = Preference(category: "type", displayTitle: "Food Type", options: [mainCourse, dessert, italian, breakfast])
            preferences.append(defaultPreference)
        }
    }
}
