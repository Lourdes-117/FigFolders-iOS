//
//  UIViewControllerUtility.swift
//  FigFolders
//
//  Created by Lourdes on 5/11/21.
//

import UIKit
import MapKit
import CoreLocation
import MessageKit

func getProfilePicPathFromUsername(_ username: String) -> String {
    return "\(StringConstants.shared.storage.profilePicturePath)/\(username)"
}

extension UIViewController {
    
    /// Generic ViewController Initialization
    /// - Precondition: Both the custom VC class name and it's storyboard name should be same
    /// - Returns: GenericViewController
    static func initiateVC() -> Self? {
        let storyBoard = UIStoryboard(name: String(describing: self), bundle: Bundle.main)

        return storyBoard.instantiateViewController(withIdentifier: String(describing: self)) as? Self
    }
    
    /// Generic ViewController Initialization
    /// - Precondition: Both the NC's first VC's custom class name and it's storyboard name should be same
    /// - Returns: GenericNavigationController
    static func initiateNC() -> UINavigationController? {
        let storyBoard = UIStoryboard(name: String(describing: self), bundle: Bundle.main)

        return storyBoard.instantiateInitialViewController() as? UINavigationController
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func openAppleMapsWithLocation(_ location: (LocationItem)) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: location.location.coordinate))
        source.name = "\(location.location.coordinate.latitude),\(location.location.coordinate.longitude)"
        MKMapItem.openMaps(
            with: [source]
        )
    }
}
