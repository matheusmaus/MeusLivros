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
    @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        startLottie()
    }


  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let user = DataSingleton.sharedInstance.getUser()
    emailLabel.text = user.email
    userNameLabel.text = user.name
  }
    
    // MARK: - Lottie
     
     func startLottie() {
         animationProfile.animation = Animation.named("whale")
         animationProfile.loopMode = .loop
         animationProfile.play()
     }
    
    // MARK: - Logout

    @IBAction func onBtnLogout(_ sender: Any) {
        _ = DataSingleton.sharedInstance.logout()
        Analytics.logEvent("logout", parameters: [:])
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let initialVIewController = storyBoard.instantiateViewController(withIdentifier: "emailViewController")
      initialVIewController.modalPresentationStyle = .fullScreen
        present(initialVIewController, animated: true)
    }

    @IBAction func editButton(_ sender: Any) {
      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
      let perfilViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController")
      perfilViewController.modalPresentationStyle = .currentContext
      present(perfilViewController, animated: true)
    }
}
