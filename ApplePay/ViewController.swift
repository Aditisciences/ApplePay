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
        
    }
    private func configureApplePayButton() {
        
        if Stripe.deviceSupportsApplePay() {
            ApplePayManager.shared = ApplePayManager()
            for subview in applePayView.subviews {
                subview.removeFromSuperview()
            }
           let applePayButton = ApplePayManager.shared?.applePayButton(on: self.applePayView)
            self.applePayView.addSubview(applePayButton!)
           ApplePayManager.shared?.currentViewController = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       configureApplePayButton()
    }


}

