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
    var availablePreferences: [Preference] = []
    var needToExpand: [Bool] = [true, true, true, true]
    var userPreferences: [Preference] = []
    var saveButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Preferences"
        setUpModel()
        fetchPreference()
        setUpTable()
        setUpBarButton()
    }

    func setUpBarButton() {
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        saveButton.isEnabled = false
        navigationItem.setRightBarButton(saveButton, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        if saveButton.isEnabled {
            showAlert("Do you want save the changes?")
        }
    }

    func setUpModel() {
        availablePreferences = Preference.getAllPreferenceOptions()
    }

    func setUpTable() {
        let headerNib = UINib.init(nibName: "PreferenceHeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }

    @objc func saveTapped() {
        savePreference()
        saveButton.isEnabled = false
    }

    func removePreference(preference: Preference, option: PreferenceOption) {
        for index in 0..<userPreferences.count {
            userPreferences[index].options.removeAll(where: {$0.apiName == option.apiName})
                        if userPreferences[index].options.count == 0 {
                            userPreferences.remove(at: index)
                        }
            break
        }
    }

    func addPreference(preference: Preference, option: PreferenceOption) {

        var isPresent = false
        /*if (userPreferences.contains( where: { $0.apiCategory == preference.apiCategory })) {
            print("this item is already present")
            var existingPreference = userPreferences.remove(at: index)
            //existingPreference = Preference(category: removed.category, displayTitle: removed.displayTitle, options: removed.options)
            if existingPreference.options.contains(option) {
                userPreferences.append(existingPreference)
            } else {
                existingPreference.options.append(option)
                userPreferences.append(existingPreference)
            }
            isPresent = true
            //break
        }*/
        for index in 0..<userPreferences.count {
            if userPreferences[index].apiCategory == preference.apiCategory {
               var existingPreference = userPreferences.remove(at: index)
                //existingPreference = Preference(category: removed.category, displayTitle: removed.displayTitle, options: removed.options)
                if existingPreference.options.contains(option) {
                    userPreferences.append(existingPreference)
                } else {
                    existingPreference.options.append(option)
                    userPreferences.append(existingPreference)
                }
                isPresent = true
                break
            }
        }
        if !isPresent {
            let userPreference = Preference(apiCategory: preference.apiCategory, displayTitle: preference.displayTitle, options: [option])
            userPreferences.append(userPreference)
        }

    }

    func savePreference() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userPreferences) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "UserPreference")
            NotificationCenter.default.post(name: reloadPageNotification, object: nil, userInfo: nil)
            print("saved")
        }
    }

    func fetchPreference() {
        if let savedPreference = UserDefaults.standard.object(forKey: "UserPreference") as? Data {
            let decoder = JSONDecoder()
            do {
                let savedPreference = try decoder.decode([Preference].self, from: savedPreference)
                print(savedPreference)
                userPreferences = savedPreference
            } catch let error {
                print(error)
            }
        }
    }

    @objc func sectionTapped(sender: UIButton) {
            let section = sender.tag
            needToExpand[section] = !needToExpand[section]
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Changes are not saved", message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ in
            self.savePreference()
        })
        alert.addAction(saveAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return availablePreferences.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if needToExpand[section] {
            return 0
        } else {
            return availablePreferences[section].options.count
        }

    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as? PreferenceHeaderView else { preconditionFailure("header view is not available") }
        headerView.categoryLabel.text = availablePreferences[section].displayTitle
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
        let preference = availablePreferences[indexPath.section]
        cell.optionLabel.text = preference.options[indexPath.row].displayTitle
        if userPreferences.contains(where: { $0.apiCategory == preference.apiCategory }) {
            for i in 0..<userPreferences.count {
                if userPreferences[i].options.contains(preference.options[indexPath.row]) {
                    print("match found ",preference.options[indexPath.row])
                    cell.accessoryType = .checkmark
                    break
                }
                else {
                    cell.accessoryType = .none
                    //break
                }
            }
        }
        /*let alreadyPreferedOption = userPreferences.filter { $0 == preference }
        if !alreadyPreferedOption.isEmpty {
            print("match found")
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }*/
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let preference = availablePreferences[indexPath.section]
        let selectedOption = preference.options[indexPath.row]
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            addPreference(preference: preference, option: selectedOption)
            cell?.accessoryType = .checkmark
        } else {
            removePreference(preference: preference, option: selectedOption)
            cell?.accessoryType = .none
        }
        saveButton.isEnabled = true
        print("***************/n/n", userPreferences, "*****************/n/n")

    }
}
