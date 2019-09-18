//
//  LittleBGTwo.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 14/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import Foundation
import UIKit

class LittleBGTwo: UIView {

    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor(red: 215.0/255.0, green: 65.0/255.0, blue: 119.0/255.0, alpha: 1.0).cgColor,
                                UIColor(red: 255.0/255.0, green: 233.0/255.0, blue: 138.0/255.0, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
    }

}
