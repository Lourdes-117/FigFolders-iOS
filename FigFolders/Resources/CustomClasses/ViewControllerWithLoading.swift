//
//  ViewControllerWithLoading.swift
//  FigFolders
//
//  Created by Lourdes on 5/21/21.
//

import UIKit
import NVActivityIndicatorView

class ViewControllerWithLoading: UIViewController {
    /// Shows Loading Indicator Over Full Screen
    private var activityBackgroundView: UIView?
    private var activityView: NVActivityIndicatorView?
    
    func showLoadingIndicator(with type: NVActivityIndicatorType = .triangleSkewSpin, color: UIColor = .blue) {
        activityBackgroundView = UIView(frame: view.frame)
        activityBackgroundView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        activityView = NVActivityIndicatorView(frame: CGRect(x: (view.frame.width/2)-50,
                                                                 y: (view.frame.height/2)-50,
                                                                 width: 100,
                                                                 height: 100),
                                                   type: type,
                                                   color: color,
                                                   padding: 0)
        guard let activityBackgroundView = activityBackgroundView,
              let activityView = activityView else { return }
        activityBackgroundView.addSubview(activityView)
        activityView.startAnimating()
        view.addSubview(activityBackgroundView)
    }
    
    func hideLoadingIndicatorView() {
        guard let activityView = activityView,
              let activityBackgroundView = activityBackgroundView else { return }
        activityView.stopAnimating()
        activityBackgroundView.removeFromSuperview()
    }
}