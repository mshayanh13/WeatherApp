//
//  Location.swift
//  WeatherApp
//
//  Created by Mohammad Hemani on 3/9/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import Foundation

class Location: NSObject, NSCoding {
    
    private var _city: String!
    private var _state: String
    private var _zipCode: String!
    private var _countryCode: String!
    
    init(city: String, state: String, zip: String, country: String) {
        
        _city = city
        _state = state
        _zipCode = zip
        _countryCode = country
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //self.init()
        _city = aDecoder.decodeObject(forKey: "city") as! String!
        _state = aDecoder.decodeObject(forKey: "state") as! String
        _zipCode = aDecoder.decodeObject(forKey: "zipCode") as! String!
        _countryCode = aDecoder.decodeObject(forKey: "countryCode") as! String!
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self._city, forKey: "city")
        aCoder.encode(self._state, forKey: "state")
        aCoder.encode(self._zipCode, forKey: "zipCode")
        aCoder.encode(self._countryCode, forKey: "countryCode")
        
    }
    
    var city: String {
        return _city
    }
    
    var state: String {
        return _state
    }
    
    var zipCode: String {
        return _zipCode
    }
    
    var countryCode: String {
        return _countryCode
    }
}
