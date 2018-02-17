//
//  MapController.swift
//  Ntwrk
//
//  Created by Hayley Eckert on 1/27/18.
//  Copyright © 2018 Hayley Eckert. All rights reserved.
//
class MSCCoordinates : NSObject, MKAnnotation{
    var coordinate = CLLocationCoordinate2D(latitude: 30.6117, longitude: -96.3417)
    var title: String? = "MSC"
}
class AirportCoordinates : NSObject, MKAnnotation{
    var coordinate = CLLocationCoordinate2D(latitude: 30.5910076, longitude: -96.3627607)
    var title: String? = "Easterwood Airport"
}
import UIKit
import MapKit
import CoreLocation
import UserNotifications
//import AlamoFire

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()
    @IBOutlet var mapView: MKMapView!
    
    let ENTERED_REGION_MESSAGE = "Entered MSC"
    let EXITED_REGION_MESSAGE = "Leave MSC"
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = UIColor.blue
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.alpha = 0.5
        circleRenderer.lineWidth = 1
        return circleRenderer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        let initialLocation = CLLocation(latitude: 30.6119, longitude: -96.3417)
        //mapView.addAnnotation(MSCCoordinates())
        centerMapOnLocation(location: initialLocation)
        setupData()
        setupDataAirport()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let regionRadius : CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func zoomIn(_ sender: AnyObject) {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 2000, 2000)
        
        mapView.setRegion(region, animated: true)
    }
    
    func setupData() {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            // 2. region data
            let title = "MSC"
            let coordinate = CLLocationCoordinate2DMake(30.6122, -96.3417)
            let regionRadius = 50.0
            
            // 3. setup region
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                                         longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            region.notifyOnExit = true;
            region.notifyOnEntry = true;
            locationManager.startMonitoring(for: region)
            
            // 4. setup annotation
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate;
            restaurantAnnotation.title = "MSC";
            mapView.addAnnotation(restaurantAnnotation)
            
            // 5. setup circle
            let circle = MKCircle(center: coordinate, radius: regionRadius)
            self.mapView.add(circle)
            
        }
        else {
            print("System can't track regions")
        }
    }
    
    func setupDataAirport() {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            // 2. region data
            let title1 = "Easterwood Airport"
            let coordinate1 = CLLocationCoordinate2DMake(30.5910076, -96.3627607)
            let regionRadius1 = 50.0
            
            // 3. setup region
            let region1 = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate1.latitude,
                                                                         longitude: coordinate1.longitude), radius: regionRadius1, identifier: title1)
            region1.notifyOnExit = true;
            region1.notifyOnEntry = true;
            locationManager.startMonitoring(for: region1)
            
            // 4. setup annotation
            let restaurantAnnotation1 = MKPointAnnotation()
            restaurantAnnotation1.coordinate = coordinate1;
            restaurantAnnotation1.title = "Easterwood Airport";
            mapView.addAnnotation(restaurantAnnotation1)
            
            // 5. setup circle
            let circle1 = MKCircle(center: coordinate1, radius: regionRadius1)
            self.mapView.add(circle1)
            
        }
        else {
            print("System can't track regions")
        }
    }
 
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started Monitoring Region: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(ENTERED_REGION_MESSAGE)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(EXITED_REGION_MESSAGE)
    }
    
    func locationManager(_ manager: CLLocationManager,
                                  monitoringDidFailFor region: CLRegion?,
                                  withError error: Error) {
        print("MSC Fail")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MKAnnotation"
        
                let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                
                let btn = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = btn
                return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let ac = UIAlertController(title: "Live Event", message: "Ntwrk Here", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes Please", style: .cancel, handler: { // Also action dismisses AlertController when pressed.
            action in
            self.performSegue(withIdentifier: "PopViewSegue", sender: nil)
            

        }
        )
        ac.addAction(action)// add action to alert
        
        ac.addAction(UIAlertAction(title: "No Thanks", style: .default))

        present(ac, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
