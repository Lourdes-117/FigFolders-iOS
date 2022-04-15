//
//  FigFilesDisplayTableViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import Foundation
import UIKit

protocol FigFilesDisplayTableViewCell: UITableViewCell {
    func setupCell(figFile: FigFileModel)
    func setupBlurView(isFree: Bool, ownerUserName: String?, purchasedUsers: [String?]?)
    var blurView: UIView! { get set }
    var figFilesTableViewCellDelegate: FigFilesTableViewCellDelegate? { get set }
    var likeCommentShareDelegate: LikeCommentShareDelegate? { get set }
}

extension FigFilesDisplayTableViewCell {
    func setupBlurView(isFree: Bool, ownerUserName: String?, purchasedUsers: [String?]?) {
        // Set Blur Effect
        blurView.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.6
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurView.insertSubview(blurEffectView, at: 0)
        
        // Blur Effect Constraints
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: blurView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
            blurEffectView.heightAnchor.constraint(equalTo: blurView.heightAnchor),
            blurEffectView.widthAnchor.constraint(equalTo: blurView.widthAnchor)
        ])
        
        // Purchase To Continue View
        if let purchaseToContinueView = loadViewFromNib(PurchaseToContinueView.nibName) {
            purchaseToContinueView.translatesAutoresizingMaskIntoConstraints = false
            blurView.insertSubview(purchaseToContinueView, at: 0)
            // Purchase To Continue Constraints
            NSLayoutConstraint.activate([
                purchaseToContinueView.topAnchor.constraint(equalTo: blurView.topAnchor),
                purchaseToContinueView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
                purchaseToContinueView.heightAnchor.constraint(equalTo: blurView.heightAnchor),
                purchaseToContinueView.widthAnchor.constraint(equalTo: blurView.widthAnchor)
            ])
            blurView.bringSubviewToFront(purchaseToContinueView)
        }
        
        if isFree || ownerUserName == currentUserUsername {
            blurView.isHidden = true
            return
        }
        
        if purchasedUsers?.contains(currentUserUsername) ?? false {
            blurView.isHidden = true
            return
        }
        
        blurView.isHidden = false
    }
}

protocol FigFilesTableViewCellDelegate: AnyObject {
    func openProfileDetailsPage(userNameToPopulate: String)
    func openFigFileLargeView(figFile: FigFileModel?, shouldShowPurchaseScreen: Bool)
    func followOrUnfollowUser(userNameToFollowOrUnfollow: String)
}
