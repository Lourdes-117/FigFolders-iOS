//
//  PurchaseToContinueView.swift
//  FigFolders
//
//  Created by Lourdes on 3/31/22.
//

import UIKit

class PurchaseToContinueView: UIView {
    static let nibName = "PurchaseToContinueView"
    
    // MARK: - Lifecycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(PurchaseToContinueView.nibName)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(PurchaseToContinueView.nibName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(PurchaseToContinueView.nibName)
    }
}
