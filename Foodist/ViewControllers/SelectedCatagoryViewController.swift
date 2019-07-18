//
//  SelectedCatagoryViewController.swift
//  Foodist
//
//  Created by Namitha Pavithran on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class SelectedCatagoryViewController: UIViewController {
    
    //MARK:- Outlets
 
    var index = 0
    
    @IBOutlet weak var sampleLabel: UILabel!
    var sampleData = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("inside viewDidLoad ",index)
       setUpViewController()
        // Do any additional setup after loading the view.
    }
    
    func setUpViewController() {
  //  index += 1
    sampleLabel.text = "\(index) \(sampleData)"
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

