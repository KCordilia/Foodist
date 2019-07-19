//
//  BlurEffectView.swift
//  Foodist
//
//  Created by Karim Cordilia on 19/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class BlurEffectView: UIView {
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let blurEffect = UIBlurEffect(style: .light)
        self.backgroundColor = .clear
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(blurEffectView)
    }
}
