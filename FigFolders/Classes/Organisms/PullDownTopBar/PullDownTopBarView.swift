//
//  PullDownTopBarView.swift
//  FigFolders
//
//  Created by Lourdes on 6/5/21.
//

import UIKit

protocol PullDownTopBarViewDelegate: AnyObject {
    func onTapDismissButton()
}

class PullDownTopBarView: UIView {
    private let kNibName = "PullDownTopBarView"
    
// MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(kNibName)
    }
// MARK: - Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dismissButton: UIButton!

// MARK: - Variables
    weak var delegate: PullDownTopBarViewDelegate?
    
    var titleString: String = "" {
        didSet {
            title.text = titleString
        }
    }

// MARK: - Button Tap Actions
    @IBAction func onTapDismissButton(_ sender: Any) {
        delegate?.onTapDismissButton()
    }
}
