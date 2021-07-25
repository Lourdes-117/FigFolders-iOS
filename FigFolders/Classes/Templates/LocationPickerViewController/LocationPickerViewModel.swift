//
//  LocationPickerViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 6/18/21.
//

import Foundation
import UIKit
import CoreLocation

protocol LocationPickerDelegate: NSObjectProtocol {
    func selectedLocationToSend(_ location: CLLocationCoordinate2D)
}

class LocationPickerViewModel {
    let numberOfTapsRequiredOnMap = 1
    let locationPageLocation = "Location"
    let sendLocationPageLocation = "Send Location"
    let sendBarButtonImage = UIImage(systemName: "paperplane.fill")
    let okText = "Ok"
    let noLocationSelectedText = "No Location Selected"
    let pleaseSelectLocationText = "Please Select A Location To Send"
}
