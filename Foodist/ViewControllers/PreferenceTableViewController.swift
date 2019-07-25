//
//  PreferenceTableViewController.swift
//  Foodist
//
//  Created by Namitha Pavithran on 23/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class PreferenceTableViewController: UITableViewController {

    // MARK: - properties
    let headerHeight: CGFloat = 60
    let rowHeight: CGFloat = 45
    let cellIdentifier = "rowCell"
    let headerIdentifier = "preferenceHeaderView"
    var preferences: [Preference] = []
    var needToExpand: [Bool] = [true, true, true, true]
    var userPreferences: [Preference] = []
    weak var preferenceDelegate: ShowPreference?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpModel()
        setUpTable()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if !userPreferences.isEmpty {
            savePreference()
        }
        preferenceDelegate?.preferences = preferences
}

    func setUpModel() {
        preferences = Preference.getAllPreferenceOptions()
        //needToExpand = Array(repeating: true, count: preferences.count)
    }

    func setUpTable() {
        let headerNib = UINib.init(nibName: "PreferenceHeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }

    func removePreference(preference: Preference, option: PreferenceOption) {
        for index in 0..<userPreferences.count {
            userPreferences[index].options.removeAll(where: {$0.name == option.name})
                        if userPreferences[index].options.count == 0 {
                            userPreferences.remove(at: index)
                        }
            break
        }
    }

    func addPreference(preference: Preference, option: PreferenceOption) {

        var isPresent = false
        for index in 0..<userPreferences.count where userPreferences[index].catagory == preference.catagory {
               var existingPreference = userPreferences.remove(at: index)
                //existingPreference = Preference(catagory: removed.catagory, displayTitle: removed.displayTitle, options: removed.options)
                existingPreference.options.append(option)
                userPreferences.append(existingPreference)
                isPresent = true
                break
        }
        if !isPresent {
            let userPreference = Preference(catagory: preference.catagory, displayTitle: preference.displayTitle, options: [option])
            userPreferences.append(userPreference)
        }

    }

    func savePreference() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userPreferences) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "UserPreference")
        }
    }

    @objc func sectionTapped(sender: UIButton) {
            let section = sender.tag
            needToExpand[section] = !needToExpand[section]
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return preferences.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if needToExpand[section] {
            return 0
        } else {
            return preferences[section].options.count
        }

    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as? PreferenceHeaderView else { preconditionFailure("header view is not available") }
        headerView.catagoryLabel.text = preferences[section].displayTitle
        headerView.button.tag = section
        headerView.button.addTarget(self, action: #selector(sectionTapped(sender:)), for: .touchUpInside)
        if needToExpand[section] {
            headerView.button.setImage(UIImage(named: "down"), for: .normal)
            headerView.separatorView.backgroundColor = .black
        } else {
            headerView.button.setImage(UIImage(named: "up"), for: .normal)
            headerView.separatorView.backgroundColor = .white
        }
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return rowHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OptionsTableViewCell else {
            preconditionFailure("section cell not available")
        }
        cell.optionLabel.text = preferences[indexPath.section].options[indexPath.row].displayTitle
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let preference = preferences[indexPath.section]
        let selectedOption = preference.options[indexPath.row]
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            addPreference(preference: preference, option: selectedOption)
            cell?.accessoryType = .checkmark
        } else {
            removePreference(preference: preference, option: selectedOption)
            cell?.accessoryType = .none
        }
        print(userPreferences)

    }

}
