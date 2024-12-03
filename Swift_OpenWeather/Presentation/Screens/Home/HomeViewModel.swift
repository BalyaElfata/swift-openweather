import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var city: String = ""
    @Published var currentWeather: CurrentWeather?
    @Published var forecast: [Forecast] = []
    
    private let weatherService = WeatherService()
    
    var greetingMessage: String {
        "Selamat datang, \(name)!"
    }
    
    func fetchWeather() {
        guard !city.isEmpty else { return }
        
        weatherService.fetchWeather(for: city) { [weak self] weatherData in
            DispatchQueue.main.async {
                if let weatherData = weatherData {
                    self?.currentWeather = CurrentWeather(from: weatherData)
                } else {
                    print("Failed to fetch current weather data")
                }
            }
        }
        
        weatherService.fetchForecast(for: city) { [weak self] forecastData in
            guard let forecastData = forecastData?.list else { return }
            
            let dailyForecasts = self?.filterDailyForecasts(from: forecastData) ?? []
            DispatchQueue.main.async {
                self?.forecast = dailyForecasts
            }
        }
    }
    
    private func filterDailyForecasts(from forecasts: [ForecastWeather]) -> [Forecast] {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        
        let groupedByDate = Dictionary(grouping: forecasts) { forecast in
            let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
            return dateFormatter.string(from: date)
        }
        
        let filteredForecasts: [Forecast] = groupedByDate.compactMap { (date, forecasts) in
            guard date != todayString else { return nil }
            return forecasts.min(by: { abs($0.dt - 43200) < abs($1.dt - 43200) })
        }.map { Forecast(from: $0) }
        
        return filteredForecasts.sorted { $0.date < $1.date }
    }
    
    func translateWeather(weather: String) -> String {
        switch weather {
        case "Rain":
            return "Hujan"
        case "Clouds":
            return "Berawan"
        default:
            return "Cerah"
        }
    }
}
