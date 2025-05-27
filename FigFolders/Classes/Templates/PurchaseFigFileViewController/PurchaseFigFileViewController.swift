//
//  PurchaseFigFileViewController.swift
//  FigFolders
//
//  Created by Lourdes on 4/15/22.
//

import UIKit
import Stripe
import SnapKit

class PurchaseFigFileViewController: ViewControllerWithLoading {
  // MARK: - Public Properties
  var figFile: FigFileModel?
  
  @IBOutlet weak var ownerNameDetails: UILabel!
  @IBOutlet weak var fileNameDetails: UILabel!
  @IBOutlet weak var fileTypeDetails: UILabel!
  @IBOutlet weak var priceDetails: UILabel!
  @IBOutlet weak var detailsStackView: UIStackView!
  
  // MARK: - Stripe Subviews
  private var cardTextField: STPPaymentCardTextField = {
    let textField = STPPaymentCardTextField()
    return textField
  }()
  
  // MARK: - Private Properties
  private let viewModel = PurchaseFigFileViewModel()
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubViews()
  }
  
  private func setupSubViews() {
    self.title = viewModel.pageTitle
    
    ownerNameDetails.text = figFile?.ownerUsername
    fileNameDetails.text = figFile?.fileName
    fileTypeDetails.text = figFile?.fileType
    priceDetails.text = "\(figFile?.filePrice ?? 0)"
    
    view.addSubview(cardTextField)
    cardTextField.snp.makeConstraints { make in
      make.leading.equalTo(view).offset(16)
      make.trailing.equalTo(view).offset(-16)
      make.top.equalTo(detailsStackView.snp.bottom).offset(16)
    }
  }
  
  @IBAction func onTapPurchaseFigFile(_ sender: Any) {
    guard let figFile else { return }
    showLoadingIndicator()
    viewModel.createPaymentIntent(figFile: figFile) { [weak self] response, error in
      guard let self else { return }
      self.hideLoadingIndicatorView()
      guard let clientSecret = response?.clientSecret else {
        self.showAlert(title: "Error fetching payment details", subTitle: "")
        return
      }
      let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
      paymentIntentParams.paymentMethodParams = self.cardTextField.paymentMethodParams
      viewModel.submitPayment(intent: paymentIntentParams, context: self) { paymentStatus, intent, error in
        debugPrint(paymentStatus)
        debugPrint(intent)
        debugPrint(error)
      }
    }
  }
}

extension PurchaseFigFileViewController: STPAuthenticationContext {
  func authenticationPresentingViewController() -> UIViewController {
    return self
  }
}
