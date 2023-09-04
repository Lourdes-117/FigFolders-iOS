//
//  PurchaseFigFileViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 4/15/22.
//

import Foundation
import Stripe

class PurchaseFigFileViewModel {
  let pageTitle = "Purchase FigFile"
  
  func createPaymentIntent(figFile: FigFileModel, completion: @escaping (_ response: PaymentIntentResponseModel?, _ error: String?) -> Void) {
    guard var price = figFile.filePrice else {
      return
    }
    price = price * 100
    let priceInt = Int(price)
    var request = PaymentIntentRequestModel(amount: "\(priceInt)")
    request.currency = "USD"
    CloudFunctionsManager.shared.createPaymentIntenet(request: request) { result in
      switch result {
      case .success(let response):
        completion(response, nil)
      case .failure(let error):
        completion(nil, error.localizedDescription)
      }
    }
  }
  
  func submitPayment(intent: STPPaymentIntentParams, context: STPAuthenticationContext, completion: @escaping ((_ paymentStatus: STPPaymentHandlerActionStatus?, _ intent: STPPaymentIntent?, _ error: NSError?) -> Void)) {
    let paymentHandler = STPPaymentHandler.shared()
    paymentHandler.confirmPayment(intent, with: context) { status, intent, error in
      completion(status, intent, error)
    }
  }
}
