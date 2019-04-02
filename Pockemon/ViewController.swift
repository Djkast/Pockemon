//
//  ViewController.swift
//  Pockemon
//
//  Created by LABMAC07 on 01/03/19.
//  Copyright © 2019 kast. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate {
    var mapView:GMSMapView!
    let locationManager = CLLocationManager()
    var listPockemon = [Pockemon]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPockemons()
        
        let camera = GMSCameraPosition(latitude: 43, longitude: -77, zoom: 10)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        self.mapView.delegate = self
        
        //Get user location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Tap at -> Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
        self.listPockemon.append(Pockemon(latitude: coordinate.latitude, longitude: coordinate.longitude, image: "bulbasaur", name: "bulbasaur", des: "bulbasaur living in japan", power:55))
        for pockemon in listPockemon{
            
            if pockemon.isCatch == false {
                let markerpockemon = GMSMarker()
                markerpockemon.position = CLLocationCoordinate2D(latitude: pockemon.latitude!, longitude: pockemon.longitude!)
                markerpockemon.title = pockemon.name!
                markerpockemon.snippet = "\(pockemon.des!), power \(pockemon.power!)"
                markerpockemon.icon = UIImage(named:pockemon.image!)
                markerpockemon.map = self.mapView
            }
        }
    }

    var myLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = manager.location!.coordinate
        print("myLocation:\(myLocation)")
        self.mapView.clear()
        //My location
        let markerMe = GMSMarker()
        markerMe.position = CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude)
        markerMe.title = "Me"
        markerMe.snippet = " here is my location"
        markerMe.icon = UIImage(named:"totodile")
        markerMe.map = self.mapView
        
        
        //Show pockemons
        var index = 0
        for pockemon in listPockemon{
            
            if pockemon.isCatch == false {
                let markerpockemon = GMSMarker()
                markerpockemon.position = CLLocationCoordinate2D(latitude: pockemon.latitude!, longitude: pockemon.longitude!)
                markerpockemon.title = pockemon.name!
                markerpockemon.snippet = "\(pockemon.des!), power \(pockemon.power!)"
                markerpockemon.icon = UIImage(named:pockemon.image!)
                markerpockemon.map = self.mapView
                
                //Catch pockemo
                if (Double(myLocation.latitude).roundTo(places: 4) ==
                    Double(pockemon.latitude!).roundTo(places: 4)) &&
                    (Double(myLocation.longitude).roundTo(places: 4) ==
                        Double(pockemon.longitude!).roundTo(places: 4)){
                    listPockemon[index].isCatch = true
                    AlertDialog(PockemonPower: pockemon.power!)
                }
            }
            index = index + 1
        }
        
        let camera = GMSCameraPosition(latitude: myLocation.latitude, longitude: myLocation.longitude, zoom: 15)
        self.mapView.camera = camera
        
    }
    var playerPower:Double = 0.0
    func loadPockemons(){
        self.listPockemon.append(Pockemon(latitude: 37.7789994893035, longitude: -122.401846647263, image: "bulbasaur", name: "bulbasaur", des: "bulbasaur living in japan", power:55))
        self.listPockemon.append(Pockemon(latitude: 37.7949568502667, longitude: -122.410494089127, image: "pikachu", name: "pikachu", des: "pikachu living in usa", power:90.5))
        self.listPockemon.append(Pockemon(latitude: 37.7816621152613, longitude: -122.41225361824 , image: "squirtle", name: "squirtle", des: "squirtle living in iraq", power:33.5))
    }
    
    func AlertDialog(PockemonPower:Double){
        playerPower = playerPower + PockemonPower
        let alert = UIAlertController(title: "Catch new pockemon", message: "your new power \(playerPower)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:
            {action in
                //Code here
                print("+ one")}
        ))
        self.present(alert, animated: true, completion: nil)
    }

}

extension Double{
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
