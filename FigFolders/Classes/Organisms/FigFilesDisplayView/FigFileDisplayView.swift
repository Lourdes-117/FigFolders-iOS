//
//  FigFilesDisplayView.swift
//  FigFilesDisplayView
//
//  Created by Lourdes on 9/14/21.
//

import UIKit

class FigFileDisplayView: UIView {
    let kNibName = "FigFileDisplayView"

// MARK: - Outlets
    @IBOutlet weak var backgroundView: UIView!

// MARK: - variables
    let viewModel = FigFileDisplayViewModel()
    
// MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(kNibName)
    }
    
// MARK: - Methods
    func setupView(figFileModel: FigFileModel?) {
        viewModel.figFile = figFileModel
        let figFileView = viewModel.getView()
        backgroundView.addSubview(figFileView)
        
        figFileView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: figFileView, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: figFileView, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: figFileView, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: figFileView, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
    }
}
