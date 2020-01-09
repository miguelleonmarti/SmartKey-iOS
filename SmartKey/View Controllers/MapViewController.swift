//
//  MapViewController.swift
//  SmartKey
//
//  Created by alumno on 27/12/2019.
//  Copyright © 2019 miguelleonmarti. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 200
    var doorList: [Door]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        // Do any additional setup after loading the view.
        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // I should change it for demo
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // Setup our location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting teh user know they have to turn this on.
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Do Map Stuff
            print("<<<<<<< .authorizedWhenInUse >>>>>>>>")
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            addAnnotations() // new one
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            print("<<<<<<< .denied >>>>>>>>")
            Alert.showBasicAlert(on: self, with: "Denied permissions", message: "Please, give permission to this app to access the location.")
            break
        case .notDetermined:
            print("<<<<<<< .notDetermined >>>>>>>>")
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show an alert letting them know what's up
            print("<<<<<<< .restricted >>>>>>>>")
            break
        case .authorizedAlways:
            print("<<<<<<< .authorizedAlways >>>>>>>>")
            break
        }
    }
    
    func addAnnotations() {
        // Adding doors location on the map
        var annotations: [MKPointAnnotation] = []
        for door in doorList! {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(door.latitude)!, longitude: Double(door.longitude)!)
            annotation.title = door.name
            if door.open {
                annotation.subtitle = "OPEN"
            } else {
                annotation.subtitle = "CLOSED"
            }
            
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
    }
    
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
