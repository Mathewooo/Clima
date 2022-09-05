import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var weatherCondition: UIImageView!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var degreeValue: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var weatherManager: WeatherManager = WeatherManager()
    var locationManager: CLLocationManager = CLLocationManager()
    
    var currentLocation: String?
    var initialPlaceHolder: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationField.delegate = self
        weatherManager.weatherDelegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        initialPlaceHolder = locationField.placeholder!
    }
    
    @IBAction func locateUserLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            locationManager.stopUpdatingLocation()
            weatherManager.fetchWeather(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        return
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel) {
        let conditionData: (String, UIImage) = weather.conditionData
        updateUI(ima: conditionData.1, cond: conditionData.0, temp: weather.temperatureString, loc: weather.cityName)
    }
    
    func didFailWithError(_ error: Error) {
        updateUI(ima: UIImage(systemName: "x.circle")!, cond: "Error", temp: "0.0", loc: "unknown")
    }
    
    func updateUI(ima: UIImage, cond: String, temp: String, loc: String) {
        DispatchQueue.main.async { [self] in
            weatherCondition.image = ima
            weatherConditionLabel.text = cond
            degreeValue.text = temp
            locationLabel.text = loc
        }
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        _ = finishLocationEditing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        finishLocationEditing()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if !textField.text!.isEmpty {
            setPlaceHolder(initialPlaceHolder!)
            return true
        } else {
            setPlaceHolder("Type something")
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherManager.fetchWeather(location: textField.text!)
        textField.text = ""
    }
    
    func finishLocationEditing() -> Bool {
        let loc: String? = locationField.text!
        if let loc = loc {
            if locationField.isEditing {
                locationField.endEditing(true)
            }
            currentLocation = loc
            return true
        }
        return false
    }
    
    func setPlaceHolder(_ str: String) {
        locationField.placeholder = str
    }
}
