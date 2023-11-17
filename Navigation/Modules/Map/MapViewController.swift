
import MapKit
import UIKit

final class MapViewController: UIViewController {
    
    private let mapView: CustomMapView = CustomMapView()

    private var locationService: LocationService?
    private var annotationSource: MKPointAnnotation?
    private var annotationDestination: MKPointAnnotation?
    private var isRouteBuilded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let locationService else { return }
        locationService.updateauthorizationStatus()
    }
    
    private func setupView() {
        locationService = LocationService()
        mapView.customDelegate = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressGesture.minimumPressDuration = 1
        mapView.addGestureRecognizer(longPressGesture)
        view = mapView
    }
    
    private func addAnnotation(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        
        if title == "Source" {
            annotationSource = annotation
            isRouteBuilded = false
        } else if title == "Destination" {
            if let existingDestination = annotationDestination {
                mapView.removeAnnotation(existingDestination)
            }
            annotationDestination = annotation
        }
        
        mapView.addAnnotation(annotation)
    }
    
    private func removeAllAnnotations(_ sender: UIButton) {
        mapView.removeAnnotations(mapView.annotations)
        annotationSource = nil
        annotationDestination = nil
        sender.isHidden = true
    }
    
    private func buildTheRoute(_ sender: UIButton) {
        guard let annotationSource,
              let annotationDestination
        else {
            return
        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: annotationSource.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotationDestination.coordinate))
        
        let direction = MKDirections(request: request)
        direction.calculate { [weak self] response, error in
            guard let self else { return }
            if let error {
                Alert().showAlert(on: self, title: "Error", message: error.localizedDescription)
                removeAllAnnotations(sender)
                return
            }
            
            if let response,
               let route = response.routes.first {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                sender.setTitle("Reset Route", for: .normal)
                sender.setImage(UIImage(systemName: "xmark"), for: .normal)
                isRouteBuilded = true
            }
        }
    }
    
    private func resetRoute(_ sender: UIButton) {
        mapView.removeOverlays(mapView.overlays)
        removeAllAnnotations(sender)
        isRouteBuilded = false
        sender.setTitle("Build the Route", for: .normal)
        sender.setImage(UIImage(systemName: "point.bottomleft.forward.to.arrowtriangle.uturn.scurvepath"), for: .normal)
    }
    
    private func showLocationServicesAlert() {
        let alertController = UIAlertController(
            title: "Location permisson",
            message: "Permission is required to use location. Please allow in the application settings",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(
            title: "Application settings",
            style: .default
        ) { _ in
            if let bundleIdentifier = Bundle.main.bundleIdentifier, let settingsURL = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func longPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        if isRouteBuilded {
            return
        }
        
        if annotationSource == nil {
            addAnnotation(coordinate: coordinate, title: "Source")
            return
        } else {
            addAnnotation(coordinate: coordinate, title: "Destination")
            if annotationDestination != nil {
                mapView.routeButton.isHidden = false
            }
            return
        }
    }
}

extension MapViewController: CustomMapViewDelegate {
    func segmentControlTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    func locationButtonTapped() {
        guard let locationService else { return }
        if locationService.isLocationAuthorized {
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(.follow, animated: true)
        } else {
            showLocationServicesAlert()
        }
    }
    
    func routeButtonTapped(_ sender: UIButton) {
        if isRouteBuilded {
            resetRoute(sender)
        } else {
            buildTheRoute(sender)
        }
    }
}
