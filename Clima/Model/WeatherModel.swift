import UIKit

struct WeatherModel {
    let conditionID: UInt16
    let cityName: String
    let temperature: Float
    
    init(id: UInt16, str: String, temp: Float) {
        conditionID = id
        cityName = str
        temperature = temp
    }
    
    var temperatureString: String {
        String(format: "%.1f", temperature)
    }
    
    var conditionData: (String, UIImage) {
        var result: (String, UIImage)?
        switch conditionID {
        case 200...232:
            result = createWeatherResult("ThunderStorm", "cloud.bolt.fill")
        case 300...321:
            result = createWeatherResult("Drizzle", "cloud.drizzle.fill")
        case 500...531:
            result = createWeatherResult("Rain", "cloud.rain.fill")
        case 600...622:
            result = createWeatherResult("Snow", "cloud.snow.fill")
        case 701...781:
            result = createWeatherResult("Fog", "cloud.fog.fill")
        case 800:
            result = createWeatherResult("Clear", "sun.max.fill")
        case 800...804:
            result = createWeatherResult("Cloudy", "cloud.fill")
        default: break
        }
        return result ?? ("Error was encoutered when accessing weatherID", UIImage(systemName: "sun.max.trianglebadge.exclamationmark.fill")!)
    }
    
    private func createWeatherResult(_ str: String, _ image: String) -> (String, UIImage) {
        return (str, UIImage(systemName: image)!)
    }
}
