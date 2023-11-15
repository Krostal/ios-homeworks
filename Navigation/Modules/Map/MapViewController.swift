

import MapKit
import UIKit

final class MapViewController: UIViewController {
    
    private let mapView = MKMapView()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.insertSegment(withTitle: "Standard", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "Satelite", at: 1, animated: true)
        segmentControl.insertSegment(withTitle: "Hybrid", at: 2, animated: true)
        segmentControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        return segmentControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupView() {
        view = mapView
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(segmentControl)
    }
    
    private func setupConstraints() {
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentControl.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            segmentControl.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -25),
            segmentControl.heightAnchor.constraint(equalToConstant: 20),
            segmentControl.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaGuide.leadingAnchor, constant: 50),
            segmentControl.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaGuide.trailingAnchor, constant: -50),
            
        ])
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
}
