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
 /*   @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK:- Properties
    let cellIdentifier = "selectedCatagoryCell"*/
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

/*extension SelectedCatagoryViewController: UICollectionViewDataSource,UISearchControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SelectedCatagoryCollectionViewCell
            else { preconditionFailure("deque cell failed in selected catagory collection view ") }
        return cell
    }
    
    
}*/
