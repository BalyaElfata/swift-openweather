import Foundation

struct ForecastData: Codable {
    let list: [ForecastWeather]?
}

struct ForecastWeather: Codable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherCondition]
}

struct Forecast: Codable, Identifiable {
    var id = UUID()
    let date: String
    let temperature: Double
    let condition: String
    let icon: String

    init(from forecastWeather: ForecastWeather) {
        let date = Date(timeIntervalSince1970: TimeInterval(forecastWeather.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        self.date = dateFormatter.string(from: date)

        self.temperature = forecastWeather.main.temp
        self.condition = forecastWeather.weather.first?.main ?? "Unknown"
        self.icon = forecastWeather.weather.first?.icon ?? ""
    }
}


