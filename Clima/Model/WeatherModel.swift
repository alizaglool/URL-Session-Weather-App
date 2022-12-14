//
//  WeatherModel.swift
//  Clima
//
//  Created by Zaghloul on 26/07/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let cityName: String
    let ConditionId: Int
    let temperture: Double
    
    // Comuted Properties
    
    var temertureString: String {
        return String(format: "%.0f", temperture)
    }
    
    var ConditionName: String {
        switch ConditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
   
}
