
import CoreLocation
import MapKit
import UIKit

final class MapViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    
    private lazy var mapView = MKMapView()

    private var annotationSource: MKPointAnnotation?
    private var annotationDestination: MKPointAnnotation?
    private var isRouteBuilded: Bool = false
    private var isLocationAuthorized: Bool = false
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.insertSegment(withTitle: "Standard", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "Satelite", at: 1, animated: true)
        segmentControl.insertSegment(withTitle: "Hybrid", at: 2, animated: true)
        segmentControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        return segmentControl
    }()
    
    private lazy var locationButton: UIButton = {
        let locationButton = UIButton(type: .system)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setTitle("Find me", for: .normal)
        locationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        locationButton.tintColor = .black
        locationButton.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        return locationButton
    }()
    
    private lazy var routeButton: UIButton = {
        let routeButton = UIButton(type: .system)
        routeButton.translatesAutoresizingMaskIntoConstraints = false
        routeButton.setTitle("Build the Route", for: .normal)
        routeButton.setImage(UIImage(systemName: "point.bottomleft.forward.to.arrowtriangle.uturn.scurvepath"), for: .normal)
        routeButton.tintColor = .black
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        routeButton.isHidden = true
        return routeButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager?.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager?.stopUpdatingLocation()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    private func setupView() {
        mapView.delegate = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressGesture.minimumPressDuration = 1
        mapView.addGestureRecognizer(longPressGesture)
        view = mapView
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(segmentControl)
        view.addSubview(locationButton)
        view.addSubview(routeButton)
    }
    
    private func setupConstraints() {
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentControl.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            segmentControl.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -25),
            segmentControl.heightAnchor.constraint(equalToConstant: 20),
            segmentControl.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaGuide.leadingAnchor, constant: 50),
            segmentControl.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaGuide.trailingAnchor, constant: -50),
            
            locationButton.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -10),
            locationButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -25),
            locationButton.heightAnchor.constraint(equalToConstant: 20),
            
            routeButton.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -10),
            routeButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 25),
            routeButton.heightAnchor.constraint(equalToConstant: 20),
            
        ])
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
    
    private func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        annotationSource = nil
        annotationDestination = nil
        routeButton.isHidden = true
    }
    
    private func buildTheRoute() {
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
                removeAllAnnotations()
                return
            }
            
            if let response,
               let route = response.routes.first {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                routeButton.setTitle("Reset Route", for: .normal)
                routeButton.setImage(UIImage(systemName: "clear"), for: .normal)
                isRouteBuilded = true
            }
        }
    }
    
    private func resetRoute() {
        mapView.removeOverlays(mapView.overlays)
        removeAllAnnotations()
        routeButton.setTitle("Build the Route", for: .normal)
        routeButton.setImage(UIImage(systemName: "point.bottomleft.forward.to.arrowtriangle.uturn.scurvepath"), for: .normal)
        isRouteBuilded = false
    }
    
    private func showLocationServicesAlert() {
        let alertController = UIAlertController(
            title: "Разрешение местоположения",
            message: "Для использования местоположения необходимо разрешение. Пожалуйста, разрешите в настройках приложения",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(
            title: "Настройки приложения",
            style: .default
        ) { _ in
            if let bundleIdentifier = Bundle.main.bundleIdentifier, let settingsURL = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .cancel
        )
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func mapTypeChanged(_ sender: UISegmentedControl) {
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
    
    @objc private func getCurrentLocation() {
        if isLocationAuthorized {
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(.follow, animated: true)
        } else {
            showLocationServicesAlert()
        }
    }
    
    @objc private func routeButtonTapped(_ sender: UIButton) {
        if isRouteBuilded {
            resetRoute()
        } else {
            buildTheRoute()
        }
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
                routeButton.isHidden = false
            }
            return
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .systemBlue
            render.lineWidth = 5
            return render
        }
        return MKOverlayRenderer()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationAuthorized = true
        case .denied, .restricted, .notDetermined:
            isLocationAuthorized = false
        @unknown default:
            fatalError("Неизвестный статус разрешения использования местоположения")
        }
    }
}
