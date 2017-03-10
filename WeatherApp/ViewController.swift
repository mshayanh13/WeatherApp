//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mohammad Hemani on 3/9/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationButton: UIButton!

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var todayHighTemperatureLabel: UILabel!
    @IBOutlet weak var todayLowTemperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    
    @IBOutlet weak var day1WeatherImage: UIImageView!
    @IBOutlet weak var day1DayOfTheWeekLabel: UILabel!
    @IBOutlet weak var day1HighTemperatureLabel: UILabel!
    @IBOutlet weak var day1LowTemperatureLabel: UILabel!
    
    @IBOutlet weak var day2WeatherImage: UIImageView!
    @IBOutlet weak var day2DayOfTheWeekLabel: UILabel!
    @IBOutlet weak var day2HighTemperatureLabel: UILabel!
    @IBOutlet weak var day2LowTemperatureLabel: UILabel!
    
    @IBOutlet weak var day3WeatherImage: UIImageView!
    @IBOutlet weak var day3DayOfTheWeekLabel: UILabel!
    @IBOutlet weak var day3HighTemperatureLabel: UILabel!
    @IBOutlet weak var day3LowTemperatureLabel: UILabel!
    
    @IBOutlet weak var day4WeatherImage: UIImageView!
    @IBOutlet weak var day4DayOfTheWeekLabel: UILabel!
    @IBOutlet weak var day4HighTemperatureLabel: UILabel!
    @IBOutlet weak var day4LowTemperatureLabel: UILabel!
    
    @IBOutlet weak var day5WeatherImage: UIImageView!
    @IBOutlet weak var day5DayOfTheWeekLabel: UILabel!
    @IBOutlet weak var day5HighTemperatureLabel: UILabel!
    @IBOutlet weak var day5LowTemperatureLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    
    var weather: Weather!
    var location: Location!
    var forecast: Forecast!
    
    //var lastUsedLocation: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let lastUsedLocation = defaults.object(forKey: "location") as? Data {
            
            location = NSKeyedUnarchiver.unarchiveObject(with: lastUsedLocation) as! Location
            if location != nil {
                getWeather()
                getForecast()
            }
            
        }
        
        locationButton.imageView?.contentMode = .scaleAspectFit
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func getCurrentLocation(){
        
        locationManager.startUpdatingLocation()
        
    }
    
    func getWeather() {
        
        let url = getWeatherURLFromLocation()
            
        updateLocationUI()
        weather = Weather()
        weather.downloadWeatherDetails(url: url) {
            
            
            DispatchQueue.main.async {
                
                if self.weather != nil && self.weather.weatherImageId != "" {
                    self.updateWeatherUI()
                }
            }
            
        }
        
    }
    
    func getForecast() {
        
        let url = getForecastURLFromLocation()
        
        forecast = Forecast()
        forecast.downloadForecastDetails(url: url) {
            
            DispatchQueue.main.async {
                
                if self.forecast != nil && self.forecast.weatherImageIds.count > 0 {
                    self.updateForecaseUI()
                }
            }
            
        }
        
    }
    
    func getWeatherURLFromLocation() -> URL {
        
        var urlString = WEATHER_URL
        urlString = urlString.replacingOccurrences(of: "{ZIP_CODE}", with: location.zipCode)
        urlString = urlString.replacingOccurrences(of: "{COUNTRY_CODE}", with: location.countryCode)
        let url = URL(string: urlString)!
        return url
        
        
    }
    
    func getForecastURLFromLocation() -> URL {
        
        var urlString = FORECAST_URL
        urlString = urlString.replacingOccurrences(of: "{ZIP_CODE}", with: location.zipCode)
        urlString = urlString.replacingOccurrences(of: "{COUNTRY_CODE}", with: location.countryCode)
        let url = URL(string: urlString)!
        return url
        
        
    }
    
    @IBAction func locationButtonTapped(sender: UIButton) {
        
        locationManager.startUpdatingLocation()
        getCurrentLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if let placemark = placemarks?[0] {
                
                self.location = Location(city: placemark.locality!, state: placemark.administrativeArea!, zip: placemark.postalCode!, country: placemark.isoCountryCode!)
                self.saveLocation()
                
            }
            
            self.getWeather()
            self.getForecast()
            self.locationManager.stopUpdatingLocation()
        }
        
        
        
    }
    
    func saveLocation() {
        
        if location != nil {
            let savedLocation = NSKeyedArchiver.archivedData(withRootObject: location)
            let defaults = UserDefaults.standard
            defaults.set(savedLocation, forKey: "location")
        }
        
    }
    
    func updateLocationUI() {
        
        cityLabel.text = location.city
        stateLabel.text = location.state
        
    }
    
    func updateWeatherUI() {
        
        currentWeatherImage.image = UIImage(named: weather.weatherImageId)
        currentTemperatureLabel.text = weather.temperature
        
        timeLabel.text = weather.time
        dayOfTheWeekLabel.text = weather.day
        todayHighTemperatureLabel.text = weather.maxTemp
        todayLowTemperatureLabel.text = weather.minTemp
        windSpeedLabel.text = weather.windSpeed

    }
    
    func updateForecaseUI() {
        
        if forecast.weatherImageIds.count > 0
        {
            showInformationForDay(day: 1)
            day1WeatherImage.image = UIImage(named: forecast.weatherImageIds[0])
            day1DayOfTheWeekLabel.text = forecast.days[0]
            day1HighTemperatureLabel.text = forecast.maxTemps[0]
            day1LowTemperatureLabel.text = forecast.minTemps[0]
        } else {
            hideInformationForDay(day: 1)
        }
        
        if forecast.weatherImageIds.count > 1 {
            showInformationForDay(day: 2)
            day2WeatherImage.image = UIImage(named: forecast.weatherImageIds[1])
            day2DayOfTheWeekLabel.text = forecast.days[1]
            day2HighTemperatureLabel.text = forecast.maxTemps[1]
            day2LowTemperatureLabel.text = forecast.minTemps[1]
        } else {
            hideInformationForDay(day: 2)
        }
        
        if forecast.weatherImageIds.count > 2 {
            showInformationForDay(day: 3)
            day3WeatherImage.image = UIImage(named: forecast.weatherImageIds[2])
            day3DayOfTheWeekLabel.text = forecast.days[2]
            day3HighTemperatureLabel.text = forecast.maxTemps[2]
            day3LowTemperatureLabel.text = forecast.minTemps[2]
        } else {
            hideInformationForDay(day: 3)
        }
        
        if forecast.weatherImageIds.count > 3 {
            showInformationForDay(day: 4)
            day4WeatherImage.image = UIImage(named: forecast.weatherImageIds[3])
            day4DayOfTheWeekLabel.text = forecast.days[3]
            day4HighTemperatureLabel.text = forecast.maxTemps[3]
            day4LowTemperatureLabel.text = forecast.minTemps[3]
        } else {
            hideInformationForDay(day: 4)
        }
        
        if forecast.weatherImageIds.count > 4 {
            showInformationForDay(day: 5)
            day5WeatherImage.image = UIImage(named: forecast.weatherImageIds[4])
            day5DayOfTheWeekLabel.text = forecast.days[4]
            day5HighTemperatureLabel.text = forecast.maxTemps[4]
            day5LowTemperatureLabel.text = forecast.minTemps[4]
        } else {
            hideInformationForDay(day: 5)
        }
    }
    
    func showInformationForDay(day: Int) {
        
        switch day {
        case 1:
            day1WeatherImage.isHidden = false
            day1DayOfTheWeekLabel.isHidden = false
            day1LowTemperatureLabel.isHidden = false
            day1HighTemperatureLabel.isHidden = false
        case 2:
            day2WeatherImage.isHidden = false
            day2DayOfTheWeekLabel.isHidden = false
            day2LowTemperatureLabel.isHidden = false
            day2HighTemperatureLabel.isHidden = false
        case 3:
            day3WeatherImage.isHidden = false
            day3DayOfTheWeekLabel.isHidden = false
            day3LowTemperatureLabel.isHidden = false
            day3HighTemperatureLabel.isHidden = false
        case 4:
            day4WeatherImage.isHidden = false
            day4DayOfTheWeekLabel.isHidden = false
            day4LowTemperatureLabel.isHidden = false
            day4HighTemperatureLabel.isHidden = false
        case 5:
            day5WeatherImage.isHidden = false
            day5DayOfTheWeekLabel.isHidden = false
            day5LowTemperatureLabel.isHidden = false
            day5HighTemperatureLabel.isHidden = false
        default:
            break
        }
    }
    
    func hideInformationForDay(day: Int) {
        
        switch day {
        case 1:
            day1WeatherImage.isHidden = true
            day1DayOfTheWeekLabel.isHidden = true
            day1LowTemperatureLabel.isHidden = true
            day1HighTemperatureLabel.isHidden = true
        case 2:
            day2WeatherImage.isHidden = true
            day2DayOfTheWeekLabel.isHidden = true
            day2LowTemperatureLabel.isHidden = true
            day2HighTemperatureLabel.isHidden = true
        case 3:
            day3WeatherImage.isHidden = true
            day3DayOfTheWeekLabel.isHidden = true
            day3LowTemperatureLabel.isHidden = true
            day3HighTemperatureLabel.isHidden = true
        case 4:
            day4WeatherImage.isHidden = true
            day4DayOfTheWeekLabel.isHidden = true
            day4LowTemperatureLabel.isHidden = true
            day4HighTemperatureLabel.isHidden = true
        case 5:
            day5WeatherImage.isHidden = true
            day5DayOfTheWeekLabel.isHidden = true
            day5LowTemperatureLabel.isHidden = true
            day5HighTemperatureLabel.isHidden = true
        default:
            break
        }
        
    }


}

