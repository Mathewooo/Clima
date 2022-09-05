struct WeatherData: Decodable {
    let main: Main
    let name: String
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Float
}

struct Weather: Decodable {
    let id: UInt16
}
