//
//  HomePageControllerViewController.swift
//  CalsSales
//
//  Created by Anmol Deora on 04/05/18.
//  Copyright © 2018 deoras. All rights reserved.
//

import UIKit
import CoreLocation

class HomePageController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var statusLabel: UILabel!
    var locationManager: CLLocationManager = CLLocationManager()
    let app = UserDefaults.standard
    var date = Date()
    var timeThresholdForSendingLocUpdates = 10
    var statusLabelTimer = Timer()
    
    @IBOutlet weak var labelFooter: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        labelFooter.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func webLogout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareLocationSelected(_ sender: Any) {
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            statusLabel.text = "Sharing Live Location. . ."
            statusLabel.textColor = UIColor.green
            statusLabelTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HomePageController.toggleStatusLabel), userInfo: nil, repeats: true)
            UserDefaults.standard.removeObject(forKey: "locUpdate")
            locationManager.startUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
        }
    }
    
    @IBAction func stopSharingSelected(_ sender: Any) {
        if(statusLabelTimer.isValid){
            statusLabel.text = "Stopped Sharing. . ."
            statusLabel.textColor = UIColor.white
            statusLabelTimer.invalidate()
        }
        
        locationManager.stopUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = false
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        let latitude = String(format: "%.4f",
                               latestLocation.coordinate.latitude)
        let longitude = String(format: "%.4f",
                                latestLocation.coordinate.longitude)
       
        
        print("lat: \(latitude), long: \(longitude)")
        
        date = Date()
        if(UserDefaults.standard.object(forKey: "locUpdate") == nil){
            print("first time added")
            app.set(date, forKey: "locUpdate")
        }else{
            print("checking now...")
            let savedDate = UserDefaults.standard.object(forKey: "locUpdate") as! Date
            let result = date.timeIntervalSince(savedDate)
            let roundedResult = Int(result)
            if(roundedResult >= timeThresholdForSendingLocUpdates){
                print("now added.. \(roundedResult), \(timeThresholdForSendingLocUpdates)")
                self.sendLocationToServer(latitude, longitude);
                app.set(date, forKey: "locUpdate")
            }else{
                print("not adding.")
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func sendLocationToServer(latitude:String, longitude:String) -> Void{
        var serverSaveUrl = "http://localhost:8080/packageStatus/fetchDetails/44";
        var url = NSURL(string: serverSaveUrl)
        var urlReq =  NSMutableURLRequest(URL:url!);
        
        
    }
    
    @objc func toggleStatusLabel(){
        print("timer ran..")
        statusLabel.isHidden = !statusLabel.isHidden
    }
    
}
    

