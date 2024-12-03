import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var city: String = ""
    @Published var currentWeather: CurrentWeather?
    @Published var forecast: [Forecast] = []
    @Published var weatherData: WeatherData? = nil
    @Published var forecastData: ForecastData? = nil
    
    private let weatherService = WeatherService()
    
    var greetingMessage: String {
        "Selamat datang, \(name)!"
    }
    
    func getWeatherData() async throws {
        do {
            weatherData = try await weatherService.getWeather(city: city)
            guard let weatherData = weatherData else {
                print("Failed to retrieve weather data.")
                return 
            }
            currentWeather = CurrentWeather(from: weatherData)
            return
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func getForecastData() async throws {
        do {
            forecastData = try await weatherService.getWeatherForecast(city: city)
            
            guard let forecastList = forecastData?.list else {
                print("Failed to retrieve forecast list.")
                return
            }
            
            let dailyForecasts = filterDailyForecasts(from: forecastList)
            
            DispatchQueue.main.async {
                self.forecast = dailyForecasts
            }
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func filterDailyForecasts(from forecasts: [ForecastWeather]) -> [Forecast] {
        let groupedByDate = Dictionary(grouping: forecasts) { forecast in
            let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        
        let filteredForecasts: [Forecast] = groupedByDate.compactMap { (_, forecasts) in
            forecasts.min(by: { abs($0.dt - 43200) < abs($1.dt - 43200) })
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
