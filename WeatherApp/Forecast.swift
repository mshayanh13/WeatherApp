//
//  Forecast.swift
//  WeatherApp
//
//  Created by Mohammad Hemani on 3/9/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import Foundation

class Forecast {
    
    private var _weatherImageIds = [String]()
    private var _maxTemps = [String]()
    private var _minTemps = [String]()
    private var _days = [String]()
    
    var weatherImageIds: [String] {
        
        return _weatherImageIds
        
    }
    
    var maxTemps: [String] {
        
        return _maxTemps
        
    }
    
    var minTemps: [String] {
        
        return _minTemps
        
    }
    
    var days: [String] {
        
        return _days
        
    }
    
    
    func downloadForecastDetails(url: URL, completed: @escaping DownloadComplete) {
        
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
                
                if let list = dict["list"] as? [Dictionary<String,Any>] {
                    
                    print(list.count)
                    
                    for info in list {
                        
                        if let date = info["dt_txt"] as? String {
                            
                            let dateArray = date.components(separatedBy: " ")
                            if dateArray[1] != "12:00:00" {
                                
                                continue
                                
                            } else {
                                
                                print(date)
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd"
                                if let dateObject = formatter.date(from: dateArray[0]) {
                                    let calendar = Calendar(identifier: .gregorian)
                                    let component = calendar.component(.weekday, from: dateObject)
                                    self._days.append(component.convertDayOfWeekToString())
                                }
                                
                                if let main = info["main"] as? Dictionary<String, Any> {
                                    
                                    
                                    if let min = main["temp_min"] as? Double {
                                        
                                        self._minTemps.append(min.kelvinToFarenheitString())
                                        
                                    }
                                    
                                    if let max = main["temp_max"] as? Double {
                                        
                                        self._maxTemps.append(max.kelvinToFarenheitString())
                                        
                                    }
                                }
                                
                                if let weathers = info["weather"] as? [Dictionary<String, Any>] {
                                    
                                    let weather = weathers[0]
                                    if let icon = weather["icon"] as? String {
                                        
                                        self._weatherImageIds.append(icon)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                }
                
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }

    
}
