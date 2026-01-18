//
//  MapViewController.swift
//  AYUA
//
//  Created by Rohit Singh Dhakad  [C] on 18/01/26.
//

import UIKit
import MapKit

struct SelectedLocation {
    let currentLat: Double
    let currentLong: Double
    let currentAddress: String
    let selectedLat: Double
    let selectedLong: Double
    let selectedAddress: String
}



class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblAddress: UILabel!
    
    var onLocationSelected: ((SelectedLocation) -> Void)?
    
    
    
    // MARK: - Location
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    // Current location
    var currentLatitude: Double?
    var currentLongitude: Double?
    
    // Addresses
    var currentAddress: String?
    var selectedAddress: String?
    
    // Selected location
    var selectedLatitude: Double?
    var selectedLongitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        checkLocationPermission()
        addTapGestureOnMap()
    }
    
    // MARK: - Permission Check
    private func checkLocationPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            showPermissionAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        @unknown default:
            break
        }
    }
    
    // MARK: - Alert
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "Location Permission Required",
            message: "Please enable location permission to continue.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Map Tap Gesture
    private func addTapGestureOnMap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        selectedLatitude = coordinate.latitude
        selectedLongitude = coordinate.longitude

        addPinAndCenter(coordinate: coordinate)
        convertLocationToAddress(latitude: coordinate.latitude, longitude: coordinate.longitude, isCurrentLocation: false)
    }
    
    // MARK: - Pin & Center
    private func addPinAndCenter(coordinate: CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Reverse Geocoding
    private func convertLocationToAddress(
        latitude: Double,
        longitude: Double,
        isCurrentLocation: Bool
    ) {
        let location = CLLocation(latitude: latitude, longitude: longitude)

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                if isCurrentLocation {
                    self.currentAddress = "Address not found"
                } else {
                    self.selectedAddress = "Address not found"
                    self.lblAddress.text = "Address not found"
                }
                return
            }

            let address = [
                placemark.name,
                placemark.locality,
                placemark.administrativeArea,
                placemark.country
            ]
            .compactMap { $0 }
            .joined(separator: ", ")

            if isCurrentLocation {
                self.currentAddress = address
            } else {
                self.selectedAddress = address
                self.lblAddress.text = address
            }
        }
    }

    
    @IBAction func btnOnConfirm(_ sender: Any) {
        
        let data = SelectedLocation(
                currentLat: currentLatitude ?? 0,
                currentLong: currentLongitude ?? 0,
                currentAddress: currentAddress ?? "",
                selectedLat: selectedLatitude ?? 0,
                selectedLong: selectedLongitude ?? 0,
                selectedAddress: selectedAddress ?? ""
            )

            onLocationSelected?(data)
            navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.longitude
        
        addPinAndCenter(coordinate: location.coordinate)
        convertLocationToAddress(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            isCurrentLocation: true
        )
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate { }
