//
//  CatagoryViewController.swift
//  Foodist
//
//  Created by Namitha Pavithran on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class AllCatagoriesViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    let cellIdentifier = "allCatagoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AllCatagoriesViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllCatagoriesTableViewCell
            else { preconditionFailure("deque cell failed in selected allcatagory table view ") }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
