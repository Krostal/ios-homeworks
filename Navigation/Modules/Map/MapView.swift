

import MapKit
import UIKit

protocol CustomMapViewDelegate: AnyObject {
    func segmentControlTapped(_ sender: UISegmentedControl)
    func locationButtonTapped()
    func routeButtonTapped(_ sender: UIButton)
}

final class CustomMapView: MKMapView {
    
    private enum Constants {
        static let itemHeight: CGFloat = 20.0
        static let verticalSpacing: CGFloat = 10.0
        static let horizontalSpacing: CGFloat = 25.0
    }
    
    weak var customDelegate: CustomMapViewDelegate?
    
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
    
    lazy var routeButton: UIButton = {
        let routeButton = UIButton(type: .system)
        routeButton.translatesAutoresizingMaskIntoConstraints = false
        routeButton.setTitle("Build the Route", for: .normal)
        routeButton.setImage(UIImage(systemName: "point.bottomleft.forward.to.arrowtriangle.uturn.scurvepath"), for: .normal)
        routeButton.tintColor = .black
        routeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        routeButton.isHidden = true
        return routeButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(segmentControl)
        addSubview(locationButton)
        addSubview(routeButton)
    }
    
    private func setupConstraints() {
        
        let safeAreaGuide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentControl.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            segmentControl.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -Constants.horizontalSpacing),
            segmentControl.heightAnchor.constraint(equalToConstant: Constants.itemHeight),
            segmentControl.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaGuide.leadingAnchor, constant: Constants.horizontalSpacing * 2),
            segmentControl.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaGuide.trailingAnchor, constant: -(Constants.horizontalSpacing * 2)),
            
            locationButton.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -Constants.verticalSpacing),
            locationButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -Constants.horizontalSpacing),
            locationButton.heightAnchor.constraint(equalToConstant: Constants.itemHeight),
            
            routeButton.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -Constants.verticalSpacing),
            routeButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: Constants.horizontalSpacing),
            routeButton.heightAnchor.constraint(equalToConstant: Constants.itemHeight),
            
        ])
    }
    
    @objc private func mapTypeChanged(_ sender: UISegmentedControl) {
        customDelegate?.segmentControlTapped(sender)
    }
    
    @objc private func getCurrentLocation() {
        customDelegate?.locationButtonTapped()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        customDelegate?.routeButtonTapped(sender)
    }
    
}

extension CustomMapView: MKMapViewDelegate {
    
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
