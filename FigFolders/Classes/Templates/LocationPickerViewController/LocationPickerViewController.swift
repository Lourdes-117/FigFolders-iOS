//
//  LocationPickerViewController.swift
//  FigFolders
//
//  Created by Lourdes on 6/18/21.
//

import UIKit
import MapKit
import CoreLocation
import MessageKit

class LocationPickerViewController: UIViewController {
    
    let viewModel = LocationPickerViewModel()
    
// MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    weak var delegate: LocationPickerDelegate?
    var locationFromPreviousScreen: LocationItem?
    
    private var selectedCoordinate: CLLocationCoordinate2D?

// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        if let locationFromPreviousScreen = locationFromPreviousScreen { // If User Opens From Chat Tapping A Location, Share Button Should Not Be Available And Selected Location Should Be Annotated
            self.title = viewModel.locationPageLocation
            setupLocationFromPreviousLocation(locationFromPreviousScreen: locationFromPreviousScreen)
        } else { // No Location Should Be Annotated, Share Button Should Be Available
            self.title = viewModel.sendLocationPageLocation
            setupBarButtonItems()
            setupMap()
        }
    }
    
    private func setupBarButtonItems() {
        self.navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: viewModel.sendBarButtonImage, style: .done, target: self, action: #selector(onTapSendLocation))
    }
    
    private func setupMap() {
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapMap(_:)))
        mapTapGesture.numberOfTapsRequired = viewModel.numberOfTapsRequiredOnMap
        mapTapGesture.numberOfTouchesRequired = viewModel.numberOfTapsRequiredOnMap
        mapView.addGestureRecognizer(mapTapGesture)
    }
    
    func setupLocationMarker(location: LocationItem) {
        locationFromPreviousScreen = location
    }
    
// MARK: - Button Actions
    @objc private func onTapSendLocation() {
        navigationController?.popViewController(animated: true)
        guard let selectedCoordinate = selectedCoordinate else {
            showNoLocationSelectedAlert()
            return
        }
        delegate?.selectedLocationToSend(selectedCoordinate)
    }
    
    @objc private func onTapMap(_ gesture: UITapGestureRecognizer) {
        let tappedLocationInView = gesture.location(in: mapView)
        let coordinate = mapView.convert(tappedLocationInView, toCoordinateFrom: mapView)
        self.selectedCoordinate = coordinate
        setMarkAtLocation(coordinate)
    }
    
// MARK: - Helper Methods
    private func setupLocationFromPreviousLocation(locationFromPreviousScreen: LocationItem) {
        let pin = MKPointAnnotation()
        pin.coordinate = locationFromPreviousScreen.location.coordinate
        mapView.addAnnotation(pin)
    }
    
    private func setMarkAtLocation(_ coordinate: CLLocationCoordinate2D) {
        mapView.annotations.forEach { annotation in
            mapView.removeAnnotation(annotation)
        }
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    private func showNoLocationSelectedAlert() {
        let alert = UIAlertController(title: viewModel.noLocationSelectedText, message: viewModel.pleaseSelectLocationText, preferredStyle: .alert)
        let okAction = UIAlertAction(title: viewModel.okText, style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
