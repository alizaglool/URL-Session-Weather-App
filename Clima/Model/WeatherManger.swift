//
//  WeatherManger.swift
//  Clima
//
//  Created by Zaghloul on 25/07/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherMangerDelegate {
    func didUpdataWeather(_ weatherManager: WeatherManger,weather: WeatherModel)
    func didFialWithError(error: Error)
}

struct WeatherManger {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1af3136dc0d2449b328188f4ab930837&units=metric"
    
    var delegate: WeatherMangerDelegate?
    
    func fatchWeather(cityName: String ) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        preformRequst(with: urlString)
    }
    func fatchWeather(latitude: Double, longtude: Double){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longtude)"
        preformRequst(with: urlString)
    }
    
    func preformRequst(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, respones, error in
                if error != nil {
                    self.delegate?.didFialWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parsJOSN(safeData) {
                        self.delegate?.didUpdataWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parsJOSN(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
        let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decoderData.name
            let temp = decoderData.main.temp
            let id = decoderData.weather[0].id
            let weatherModel = WeatherModel(cityName: name, ConditionId: id, temperture: temp)
            return weatherModel
        }catch {
            delegate?.didFialWithError(error: error)
            return nil
        }
    }
}
