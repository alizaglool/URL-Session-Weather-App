//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
   
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextFiled: UITextField!
    
    var weatherManger = WeatherManger()
    var locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.delegate = self
        locationManger.requestAlwaysAuthorization()
        locationManger.requestLocation()
        
        searchTextFiled.delegate = self
        weatherManger.delegate = self
    }
    @IBAction func currentLocation(_ sender: UIButton) {
        locationManger.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController:  UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: Any) {
        searchTextFiled.endEditing(true)
        cityLabel.text = searchTextFiled.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextFiled.endEditing(true)
        print(searchTextFiled.text!)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextFiled.text {
            weatherManger.fatchWeather(cityName: city)
        }
        searchTextFiled.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            textField.placeholder = "Type Something Here"
            return false
        }
    }
    
}

//MARK: - WeatherMangerDelegate


extension WeatherViewController: WeatherMangerDelegate {
    
    func didUpdataWeather(_ weatherManager: WeatherManger,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temertureString
            self.conditionImageView.image = UIImage(systemName: weather.ConditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    func didFialWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationMangerDelegate

extension WeatherViewController: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManger.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManger.fatchWeather(latitude: lat, longtude: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
