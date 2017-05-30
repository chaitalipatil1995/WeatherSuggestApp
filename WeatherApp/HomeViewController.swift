//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Amesten Systems on 29/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var weatherConditionLabel: UILabel!
    
    @IBOutlet var currentTempLabel: UILabel!
    
    @IBOutlet var minMaxTempLabel: UILabel!
    
    let manager = CLLocationManager()
    
    var latitude : NSString = ""
    var longitude : NSString = ""
    
    let KWeatherAPIKey = "dadda7e52d90d9348dc588ce9294a5e4"

    var temperature : String = ""
    var weatherCondition : String = ""
    var minTemp : String = ""
    var maxTemp: String =  ""
    
    
    
    
    
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        revealViewController().rightViewRevealWidth = 150

        
        self.updateLocation()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLocation(){
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startMonitoringSignificantLocationChanges()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let myLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        latitude = myLocation.latitude.description as NSString
        longitude = myLocation.longitude.description as NSString
        
        print(latitude)
        print(longitude)
        
        manager.stopUpdatingLocation()
        
        self.getCurrentWeatherData(withLatitude: latitude as String, longitude: longitude as String, apiKey: KWeatherAPIKey)

        
    }

    func getCurrentWeatherData(withLatitude latitude: String, longitude: String, apiKey key: String) {
        
        let requestURL: NSURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&APPID=\(key)&units=metric")!
       // print(requestURL)
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            

                if (statusCode == 200) {
                    
                    do{
                        
                       // let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: [])
                        
                      print(jsonDictionary)
                        
                        self.temperature = "\((jsonDictionary as AnyObject).value(forKeyPath: "main.temp")!)"
                        print(self.temperature)
                        let weather: [Any]? = ((jsonDictionary as AnyObject).value(forKey: "weather") as? [Any])
                        
                        print(weather![0])
                        
                        self.weatherCondition = "\((weather![0] as AnyObject) .value(forKey: "description")!)"

                        print(self.weatherCondition)
                        
                        
                        self.minTemp = "\((jsonDictionary as AnyObject).value(forKeyPath: "main.temp_min")!)"
                        print(self.minTemp)
                        self.maxTemp = "\((jsonDictionary as AnyObject).value(forKeyPath: "main.temp_max")!)"
                        print(self.maxTemp)
                        
                        
                    }catch {
                        print("Error with Json: \(error)")
                    }
                }
            
                self.updateUI()
            
            
            }
        
        task.resume()
        
    }
 
    func updateUI(){
        
        print(weatherCondition)
        
        weatherConditionLabel.text = weatherCondition
        currentTempLabel.text = temperature
        minMaxTempLabel.text = minTemp + "˚" + "/" + maxTemp + "˚"
        

        
    }
    

}
