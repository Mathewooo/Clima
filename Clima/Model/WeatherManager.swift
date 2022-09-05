import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    var weatherDelegate: WeatherManagerDelegate?
    
    let apiKey: String? = ProcessInfo.processInfo.environment["apiKey"]
    lazy var weatherUrl: String = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey ?? "|error|")"
        
    mutating func connectUrlAndUnitType() -> String {
        let units: String = "&units=metric"
        let completeUrl: String = "\(weatherUrl)\(units)"
        return completeUrl
    }
    
    mutating func fetchWeather(location: String) {
        let url: String = connectUrlAndUnitType()
        performRequest(with: "\(url)&q=\(location)")
    }
    
    mutating func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let url: String = connectUrlAndUnitType()
        performRequest(with: "\(url)&lat=\(lat)&lon=\(lon)")
    }
    
    func performRequest(with url: String) {
        let urlString: String = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        if let url = URL(string: urlString) {
            let session: URLSession = URLSession(configuration: .default)
            let handleClosure = { (data: Data?, urlResponse: URLResponse?, error: Error?) in
                if data != nil, let weather = self.parseJsonResult(data!) {
                    self.weatherDelegate?.didUpdateWeather(weather)
                } else if error != nil { weatherDelegate?.didFailWithError(error!); return }
            }
            let task: URLSessionTask = session.dataTask(with: url, completionHandler: handleClosure)
            task.resume()
        }
    }
    
    func parseJsonResult(_ weatherData: Data) -> WeatherModel? {
        let decoder: JSONDecoder = JSONDecoder()
        do {
            let decodedData: WeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(id: decodedData.weather[0].id, str: decodedData.name, temp: decodedData.main.temp)
        } catch {
            weatherDelegate?.didFailWithError(error)
            return nil
        }
    }
}
