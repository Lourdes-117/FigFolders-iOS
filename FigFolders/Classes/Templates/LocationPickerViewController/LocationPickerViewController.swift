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
    @IBOutlet weak var currentLocationButton: UIButton!
    
    weak var delegate: LocationPickerDelegate?
    var locationFromPreviousScreen: LocationItem?
    let locationManager = CLLocationManager()
    
    private var selectedCoordinate: CLLocationCoordinate2D?

// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        currentLocationButton.setRoundedCorners()
    }
    
    private func initialSetup() {
        if let locationFromPreviousScreen = locationFromPreviousScreen { // If User Opens From Chat Tapping A Location, Share Button Should Not Be Available And Selected Location Should Be Annotated
            self.title = viewModel.locationPageLocation
            setupLocationFromPreviousLocation(locationFromPreviousScreen: locationFromPreviousScreen)
            currentLocationButton.isHidden = true
        } else { // No Location Should Be Annotated, Share Button Should Be Available
            self.title = viewModel.sendLocationPageLocation
            currentLocationButton.isHidden = false
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
        setMarkAtLocation(coordinate)
    }
    
    @IBAction func onTapCurrentLocation(_ sender: Any) {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied {
                if let bundleId = Bundle.main.bundleIdentifier,
                    let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func setupLocationFromPreviousLocation(locationFromPreviousScreen: LocationItem) {
        let pin = MKPointAnnotation()
        pin.coordinate = locationFromPreviousScreen.location.coordinate
        mapView.addAnnotation(pin)
    }
    
    private func setMarkAtLocation(_ coordinate: CLLocationCoordinate2D) {
        self.selectedCoordinate = coordinate
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
    
    private func showOnMap(location: CLLocation ) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - CLLocation Manager Delegate
extension LocationPickerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        setMarkAtLocation(locValue)
        let currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        showOnMap(location: currentLocation)
        locationManager.delegate = nil
    }
}
