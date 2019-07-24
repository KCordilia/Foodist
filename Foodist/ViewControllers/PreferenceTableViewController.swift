//
//  PreferenceTableViewController.swift
//  Foodist
//
//  Created by Namitha Pavithran on 23/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class PreferenceTableViewController: UITableViewController {

    var preferences: [Preference] = []
    var isSectionExpanded: [Bool] = []
    var userPreferences: [Preference] = []
    var preferenceDelegate: ShowPreference?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpModel()
        setUpTable()
    }

    override func viewWillDisappear(_ animated: Bool) {
        preferenceDelegate?.preferences = preferences
    }

    func setUpModel() {
        preferences = Preference.getAllPreferenceOptions()
        isSectionExpanded = Array(repeating: true, count: preferences.count)
    }

    func setUpTable() {
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
        for index in 0..<userPreferences.count {
            if userPreferences[index].catagory == preference.catagory {
               var existingPreference = userPreferences.remove(at: index)
                //existingPreference = Preference(catagory: removed.catagory, displayTitle: removed.displayTitle, options: removed.options)
                existingPreference.options.append(option)
                userPreferences.append(existingPreference)
                isPresent = true
                break
            }
        }
        if !isPresent {
            let userPreference = Preference(catagory: preference.catagory, displayTitle: preference.displayTitle, options: [option])
            userPreferences.append(userPreference)
        }

    }

    func savePreference() {

    }

    @objc func sectionTapped(sender: UITapGestureRecognizer) {
        // print(sender.view?.tag)
        let section = (sender.view?.tag)!
        let preference = preferences[section]
        let options = preference.options
        var indexPaths: [IndexPath] = []
        for index in 0..<options.count {
            indexPaths.append(IndexPath(row: index, section: section))
        }
        isSectionExpanded[section] = !isSectionExpanded[section]
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return preferences.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return preferences[section].options.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.frame.width-40, height: 40))
        headerView.addSubview(label)
        label.text = preferences[section].displayTitle
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionTapped(sender:)))
        headerView.addGestureRecognizer(gesture)
        label.backgroundColor = .lightGray
        headerView.tag = section
        //        headerView.layer.shadowColor = UIColor.lightGray.cgColor
        //        headerView.layer.shadowOpacity = 1
        //        headerView.layer.shadowOffset = .zero
        //        headerView.layer.shadowRadius = 10
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSectionExpanded[indexPath.section] {
            return 0
        } else {
            return 45
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath) as? OptionsTableViewCell else {
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
