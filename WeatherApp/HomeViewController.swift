//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Amesten Systems on 29/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//
// For hourly weather data
// http://api.openweathermap.org/data/2.5/forecast?lat=18.5204&lon=73.8567&units=imperial&cnt=12&appid=dadda7e52d90d9348dc588ce9294a5e4
import UIKit
import CoreLocation
import MBProgressHUD


class HomeViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var hourlyWeatherTableView: UITableView!
    @IBOutlet var duplicateView: UIView!
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
    var spinnerActivity: MBProgressHUD! = nil
    
    var hourCountString : String = ""

    //var hourCountArray : NSArray = []
    
    
    
    
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        revealViewController().rightViewRevealWidth = 150

        
        self.updateLocation()

        spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        spinnerActivity.label.text = "Loading";
        spinnerActivity.detailsLabel.text = "Please Wait!!";
        
        hourlyWeatherTableView.backgroundColor = UIColor.clear
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Current Location
    
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
        self.getHourWeatherData(withLatitude: latitude as String, longitude: longitude as String, apiKey: KWeatherAPIKey)

    }

    // MARK: - Current weather Data
    
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
                        DispatchQueue.main.async {
                            self.spinnerActivity.hide(animated: true)
                        }
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
    
    //MARK: - Hour weather data
    //http://api.openweathermap.org/data/2.5/forecast?lat=18.5204&lon=73.8567&units=imperial&cnt=12&appid=dadda7e52d90d9348dc588ce9294a5e4
    
    func getHourWeatherData(withLatitude latitude: String, longitude: String, apiKey key: String) {
        
        let requestURL: NSURL = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&APPID=\(key)&units=metric&cnt=12")!
        // print(requestURL)
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    DispatchQueue.main.async {
                        self.spinnerActivity.hide(animated: true)
                    }
                    // let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    print(jsonDictionary)
                    
                    self.hourCountString = "\((jsonDictionary as AnyObject) .value(forKey: "cnt")!)"
                    
                    print(self.hourCountString)

                    let myInt = (self.hourCountString as NSString).integerValue

                    for i in 0 ..< myInt {
                        
                        
                        self.temperature = "\((jsonDictionary as AnyObject).value(forKeyPath: "main.temp")!)"
                        print(self.temperature)
                        
                    }
                    
                    self.temperature = "\((jsonDictionary as AnyObject).value(forKeyPath: "main.temp")!)"
                    print(self.temperature)
                  
                    /*
                    let weather: [Any]? = ((jsonDictionary as AnyObject).value(forKey: "weather") as? [Any])
                    
                    print(weather![0])
                    
                    self.weatherCondition = "\((weather![0] as AnyObject) .value(forKey: "description")!)"
                    
                    print(self.weatherCondition)
                    
                    
                    self.minTemp = "\((jsonDictionary as AnyObject).value(forKeyPath: "main.temp_min")!)"
                    print(self.minTemp)
                    self.maxTemp = "\((jsonDictionary as AnyObject).value(forKeyPath: "main.temp_max")!)"
                    print(self.maxTemp)
                    */
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            }
            
            
            self.updateUI()
            
        }
        
        task.resume()
        
    }
    
    //Mark: - Table view Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        let cell : HourlyWeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! HourlyWeatherTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.timeLabel.font = UIFont.systemFont(ofSize: 20)
        cell.timeLabel.font = UIFont.boldSystemFont(ofSize: 22)

        cell.backgroundColor = UIColor.clear
        
        /*
        if  alarms.count > 0  {
            let alarmSTring = alarms[indexPath.row]
            
            //cell.taskLabel.text = taskSTring.value(forKey: "task") as? String
            cell.timeLabel.text = alarmSTring.value(forKey: "time") as? String
            cell.daysLabel.text = alarmSTring.value(forKey: "repeat") as? String
            
        } else {
            cell.hrTempLabel.text = ""
            cell.timeLabel.text = ""
            //cell.editButton.isUserInteractionEnabled = false
        }
        */
        return cell
    }
    
    

}
