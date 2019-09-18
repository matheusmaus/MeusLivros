//
//  LittleBGView.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 12/09/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import Foundation
import UIKit

class LittleBGView: UIView {

    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor(red: 0.0/255.0, green: 168.0/255.0, blue: 197.0/255.0, alpha: 1.0).cgColor,
                                UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 126.0/255.0, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
    }
}
