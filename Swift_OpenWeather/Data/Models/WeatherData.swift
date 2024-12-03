import Foundation

struct WeatherData: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherCondition]
}

struct CurrentWeather: Codable {
    let location: String
    let temperature: Double
    let condition: String
    let icon: String

    init(from weatherData: WeatherData) {
        self.location = weatherData.name
        self.temperature = weatherData.main.temp
        self.condition = weatherData.weather.first?.main ?? "Unknown"
        self.icon = weatherData.weather.first?.icon ?? ""
    }
}

struct WeatherCondition: Codable {
    let main: String
    let description: String
    let icon: String
}

struct MainWeather: Codable {
    let temp: Double
}
