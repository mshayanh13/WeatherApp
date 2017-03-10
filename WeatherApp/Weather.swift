//
//  Weather.swift
//  WeatherApp
//
//  Created by Mohammad Hemani on 3/9/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit

class Weather {
    
    private var _weatherImageId: String!
    private var _temperature: String!
    private var _maxTemp: String!
    private var _minTemp: String!
    private var _time: String!
    private var _day: String!
    private var _windSpeed: String!
    private var _precipitation: String!
    
    var weatherImageId: String {
        
        if _weatherImageId == nil {
            _weatherImageId = ""
        }
        return _weatherImageId
        
    }
    
    var temperature: String {
        
        if _temperature == nil {
            _temperature = ""
        }
        return _temperature
        
    }
    
    var maxTemp: String {
        
        if _maxTemp == nil {
            _maxTemp = ""
        }
        return _maxTemp
        
    }
    
    var minTemp: String {
        
        if _minTemp == nil {
            _minTemp = ""
        }
        return _minTemp
        
    }
    
    var time: String {
        
        if _time == nil {
            _time = ""
        }
        return _time
        
    }
    
    var day: String {
        
        if _day == nil {
            _day = ""
        }
        return _day
        
    }
    
    var windSpeed: String {
        
        if _windSpeed == nil {
            _windSpeed = ""
        }
        return _windSpeed
        
    }
    
    var precipitation: String {
        
        if _precipitation == nil {
            _precipitation = ""
        }
        return _precipitation
        
    }
    
    func downloadWeatherDetails(url: URL, completed: @escaping DownloadComplete) {
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                
                print(error.debugDescription)
                
            } else {
                
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode == 200 {
                        
                        if let data = data {
                            
                            self.processJSON(data: data)
                            completed()
                        }
                        
                    }
                    
                }
                
                
            }
            
        }
        task.resume()
    }
    
    func processJSON(data: Data) {
        
        do {
            
            if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> {
                
                //print(dict.debugDescription)
                if let weathers = dict["weather"] as? [Dictionary<String, Any>] {
                    
                    let weather = weathers[0]
                    if let iconName = weather["icon"] as? String {
                        self._weatherImageId = iconName
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, Double> {
                    
                    if let currentTemperature = main["temp"] {
                        
                        self._temperature = currentTemperature.kelvinToFarenheitString()
                        
                    }
                    if let maxTemp = main["temp_max"] {
                        
                        self._maxTemp = maxTemp.kelvinToFarenheitString()
                        
                    }
                    
                    if let minTemp = main["temp_min"] {
                        
                        self._minTemp = minTemp.kelvinToFarenheitString()
                        
                    }
                    
                }
                
                if let date = dict["dt"] as? UInt64 {
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(date))
                    print(date.description)
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date)
                    let minute = calendar.component(.minute, from: date)
                    let dayOfWeek = calendar.component(.weekday, from: date)
                    
                    self._time = convertTo12HourTime(hour: hour, minute: minute)
                    self._day = dayOfWeek.convertDayOfWeekToString().uppercased()
                    
                }
                
                if let wind = dict["wind"] as? Dictionary<String, Any> {
                    
                    if let speed = wind["speed"] as? Double {
                        
                        self._windSpeed = "\(speed.convertToMilesPerHour()) MPH"
                        
                    }
                    
                }
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
