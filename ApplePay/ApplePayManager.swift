//
//  ApplePayManager.swift
//  ApplePay
//
//  Created by cl-macmini-128 on 26/09/18.
//  Copyright © 2018 cl-macmini-128. All rights reserved.
//

import UIKit
import Stripe

class ApplePayManager: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    
    static var shared: ApplePayManager?
    
    var finalDiscountAmount = 0.0
    var currentViewController = UIViewController()
    
    // MARK: - CREATE PAYMENT REQUEST
    func createPaymentRequest() -> PKPaymentRequest {
        
        let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: applePayMerchantId)
       
  
            paymentRequest.paymentSummaryItems = [
                PKPaymentSummaryItem(label: "Subtotal", amount: NSDecimalNumber(string: "\(10)")),
                PKPaymentSummaryItem(label: "Gratuity" + " (\(20)%)", amount: NSDecimalNumber(string: "\(49)")),
                PKPaymentSummaryItem(label: "Loyality", amount: NSDecimalNumber(string: "\(30)")),
                PKPaymentSummaryItem(label: "Credits/Promo Code Discount", amount: NSDecimalNumber(string: "\(40)")),
                PKPaymentSummaryItem(label: "Tax" + " (\(5)%)", amount: NSDecimalNumber(string: "\(500)")),
             ]
       
        return paymentRequest
    }
    
    // MARK: - PAYMENT BUTTON ACTION
    func applePayButtonPressed() {
        
        let paymentRequestObj = self.createPaymentRequest()
        
        if Stripe.canSubmitPaymentRequest(paymentRequestObj) {
            if let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequestObj) as PKPaymentAuthorizationViewController? {
                vc.delegate = self
                currentViewController.present(vc, animated: true, completion: nil)
            } else {
               let alert = UIAlertController(title: "Error", message: "ApplePay error", preferredStyle: .alert)
        
            }
        } else {
         
        }
        
    }
    
    @objc func goToBookingSummary() {
    
    }
    
    func applePayButton(on view: UIView) -> UIButton {
        var tempButton: UIButton?
        if #available(iOS 8.3, *) { // Available in iOS 8.3+
            tempButton = PKPaymentButton(paymentButtonType:PKPaymentButtonType.plain , paymentButtonStyle: PKPaymentButtonStyle.black)
            tempButton?.frame = CGRect(x: 0, y: 20, width: 120, height: 45)
            // tempButton?.bounds = view.bounds
            tempButton?.center = view.center
            tempButton?.addTarget(self, action: #selector(ApplePayManager.goToBookingSummary), for: .touchUpInside)
        } else {
            // TODO: Create and return your own apple pay button
            // button = ...
        }
        return tempButton!
    }
    
    
    // MARK: - PKPAYMENT VC DELEGATE
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        print("\(payment.billingContact) +++++\(payment.shippingContact)")
        print("payment++++++\(payment) ")
        STPAPIClient.shared().createToken(with: payment) { (token, error) in
            guard let tokenObj = token, error == nil else {
                completion(PKPaymentAuthorizationStatus.failure)
                return
            }
            print(tokenObj.tokenId)
            print(tokenObj.stripeID)
            print(tokenObj.bankAccount)
            print(tokenObj.livemode)
            print(tokenObj.created)
            print(tokenObj.card)
            // To do Later: if cardId need
            //                            if let cardId = tokenObj.card?.cardId as? String {
            //                                print("card id ++++++\(cardId)")
            //                            }
            //
            print(tokenObj.allResponseFields)
            controller.dismiss(animated: true, completion: nil)
           
            // Then indicate success or failure via the completion callback, e.g.
            completion(PKPaymentAuthorizationStatus.success)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func applePaySupported() -> Bool {
        return PKPaymentAuthorizationViewController.canMakePayments() && PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.amex, .visa, .masterCard])
    }
}
