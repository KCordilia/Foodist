//
//  ViewController.swift
//  Foodist
//
//  Created by Karim Cordilia on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ShowPreference {

    var preferences: [Preference] = []
    var pageViewPreference: String = "dessert"
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        let mainCourse = PreferenceOption(name: "main+course", displayTitle: "Main course")
        let dessert = PreferenceOption(name: "dessert", displayTitle: "Dessert")
        let fakePreference = Preference(catagory: "type", displayTitle: "Food Type", options: [mainCourse,dessert])
        preferences.append(fakePreference)
        preferences.shuffle()
    }

    func setUpNavigationBar() {
        navigationItem.title = "Foodist"
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settingsTapped))
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }

    @objc func settingsTapped() {
        performSegue(withIdentifier: "showPreference", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPreference" {
            guard let destination = segue.destination as? PreferenceTableViewController else { return }
            destination.preferenceDelegate = self
        }
    }
}
