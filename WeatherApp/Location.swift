//
//  Location.swift
//  WeatherApp
//
//  Created by Mohammad Hemani on 3/9/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import Foundation

class Location {
    
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
