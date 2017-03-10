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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                self.updateWeatherUI()
            }
            
        }
        
    }
    
    func getForecast() {
        
        let url = getForecastURLFromLocation()
        
        forecast = Forecast()
        forecast.downloadForecastDetails(url: url) {
            
            DispatchQueue.main.async {
                
                self.updateForecaseUI()
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
        
        getCurrentLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if let placemark = placemarks?[0] {
                
                self.location = Location(city: placemark.locality!, state: placemark.administrativeArea!, zip: placemark.postalCode!, country: placemark.isoCountryCode!)
                
            }
            
            self.locationManager.stopUpdatingLocation()
            self.getWeather()
            self.getForecast()
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
        
        day1WeatherImage.image = UIImage(named: forecast.weatherImageIds[0])
        day1DayOfTheWeekLabel.text = forecast.days[0]
        day1HighTemperatureLabel.text = forecast.maxTemps[0]
        day1LowTemperatureLabel.text = forecast.minTemps[0]
        
        day2WeatherImage.image = UIImage(named: forecast.weatherImageIds[1])
        day2DayOfTheWeekLabel.text = forecast.days[1]
        day2HighTemperatureLabel.text = forecast.maxTemps[1]
        day2LowTemperatureLabel.text = forecast.minTemps[1]
        
        day3WeatherImage.image = UIImage(named: forecast.weatherImageIds[2])
        day3DayOfTheWeekLabel.text = forecast.days[2]
        day3HighTemperatureLabel.text = forecast.maxTemps[2]
        day3LowTemperatureLabel.text = forecast.minTemps[2]
        
        day4WeatherImage.image = UIImage(named: forecast.weatherImageIds[3])
        day4DayOfTheWeekLabel.text = forecast.days[3]
        day4HighTemperatureLabel.text = forecast.maxTemps[3]
        day4LowTemperatureLabel.text = forecast.minTemps[3]
        
        day5WeatherImage.image = UIImage(named: forecast.weatherImageIds[4])
        day5DayOfTheWeekLabel.text = forecast.days[4]
        day5HighTemperatureLabel.text = forecast.maxTemps[4]
        day5LowTemperatureLabel.text = forecast.minTemps[4]
        
    }


}

