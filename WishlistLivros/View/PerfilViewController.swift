//
//  PerfilViewController.swift
//  WishlistLivros
//
//  Created by Matheus Marcos Maus on 17/10/19.
//  Copyright © 2019 Matheus Marcos Maus. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class PerfilViewController: UIViewController {

    @IBOutlet weak var animationProfile: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLottie()
    }
    
    // MARK: - Lottie
     
     func startLottie() {
         
         animationProfile.animation = Animation.named("2548-3d-circle-loader")
         animationProfile.loopMode = .loop
         animationProfile.play()
     }
    
    // MARK: - Logout

    @IBAction func onBtnLogout(_ sender: Any) {
        
        DataSingleton.sharedInstance.logout()
    }
}
