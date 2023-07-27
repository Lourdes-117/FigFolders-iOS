//
//  PurchaseFigFileViewController.swift
//  FigFolders
//
//  Created by Lourdes on 4/15/22.
//

import UIKit

class PurchaseFigFileViewController: UIViewController {
  // MARK: - Public Properties
  var figFile: FigFileModel?
  
  @IBOutlet weak var ownerNameDetails: UILabel!
  @IBOutlet weak var fileNameDetails: UILabel!
  @IBOutlet weak var fileTypeDetails: UILabel!
  @IBOutlet weak var priceDetails: UILabel!
  
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
    priceDetails.text = "\(String(describing: figFile?.filePrice))"
  }
  
  @IBAction func onTapPurchaseFigFile(_ sender: Any) {
    guard let figFile else { return }
    viewModel.createPaymentIntent(figFile: figFile) { [weak self] response, error in
      guard let self else { return }
      debugPrint(response?.clientSecret)
    }
  }
}
