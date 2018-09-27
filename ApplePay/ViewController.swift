//
//  ViewController.swift
//  ApplePay
//
//  Created by cl-macmini-128 on 26/09/18.
//  Copyright © 2018 cl-macmini-128. All rights reserved.
//

import UIKit
import Stripe
class ViewController: UIViewController {

    @IBAction func ApplePayAction(_ sender: Any) {
        configureApplePayButton()
    }
    private func configureApplePayButton() {
        
        if Stripe.deviceSupportsApplePay() {
            ApplePayManager.shared = ApplePayManager()
           ApplePayManager.shared?.currentViewController = self
            ApplePayManager.shared?.applePayButtonPressed()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       configureApplePayButton()
    }


}

