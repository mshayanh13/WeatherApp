//
//  Constants.swift
//  WeatherApp
//
//  Created by Mohammad Hemani on 3/9/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import Foundation

let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?zip={ZIP_CODE},{COUNTRY_CODE}&appid=89575d3c850c4fe09a01e9aedf6aec9e"
let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast?zip={ZIP_CODE},{COUNTRY_CODE}&appid=89575d3c850c4fe09a01e9aedf6aec9e"
let APPID = "89575d3c850c4fe09a01e9aedf6aec9e"

typealias DownloadComplete = () -> ()

extension Int
{
    func kelvinToFarenheit() -> Int {
    
        let kelvin = Double(self)
        let result: Double = ((9.0/5.0)*(kelvin - 273.0)) + 32.0
        return Int(result.rounded())
    
    }
    
    func kelvinToFarenheitString() -> String {
        
        return "\(self.kelvinToFarenheit())°F"
        
    }
    
    func convertDayOfWeekToString() -> String {
        
        switch self {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
        
    }
}

extension Double
{
    func convertToMilesPerHour() -> Double {
        let answer = self * 2.23693629
        return (answer * 100).rounded() / 100
    }
    
    func kelvinToFarenheit() -> Int {
        
        let kelvin = Double(self)
        let result: Double = ((9.0/5.0)*(kelvin - 273.0)) + 32.0
        return Int(result.rounded())
        
    }
    
    func kelvinToFarenheitString() -> String {
        
        return "\(self.kelvinToFarenheit())°F"
        
    }
}

func convertTo12HourTime(hour: Int, minute: Int) -> String {
    
    if hour == 0 {
        return "12:\(minute) AM"
    }
    else if hour > 12 {
        return "\(hour - 12):\(minute) PM"
    } else {
        return "\(hour):\(minute) AM"
    }
        
}
