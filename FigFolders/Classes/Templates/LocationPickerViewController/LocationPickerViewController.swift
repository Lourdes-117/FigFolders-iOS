//
//  LocationPickerViewController.swift
//  FigFolders
//
//  Created by Lourdes on 6/18/21.
//

import UIKit
import MapKit
import CoreLocation

class LocationPickerViewController: UIViewController {
    
    let viewModel = LocationPickerViewModel()
    
// MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    weak var delegate: LocationPickerDelegate?
    
    private var selectedCoordinate: CLLocationCoordinate2D?

// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        self.title = viewModel.pageTitle
        setupBarButtonItems()
        setupMap()
    }
    
    private func setupBarButtonItems() {
        self.navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: viewModel.sendBarButtonImage, style: .done, target: self, action: #selector(onTapSendLocation))
    }
    
    private func setupMap() {
        mapView.isUserInteractionEnabled = true
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapMap(_:)))
        mapTapGesture.numberOfTapsRequired = viewModel.numberOfTapsRequiredOnMap
        mapTapGesture.numberOfTouchesRequired = viewModel.numberOfTapsRequiredOnMap
        mapView.addGestureRecognizer(mapTapGesture)
    }
    
// MARK: - Button Actions
    @objc private func onTapSendLocation() {
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
