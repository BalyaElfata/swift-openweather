import Foundation

class WeatherService {
    private let apiKey = "39be9a0b8f3a74ade269205d2bc11fc5"
    private let baseUrl = "https://api.openweathermap.org/data/2.5"

    func fetchWeather(for city: String, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "\(baseUrl)/weather?q=\(city)&units=metric&lang=id&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(weatherData)
            } catch {
                print("Failed to decode weather data: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func fetchForecast(for city: String, completion: @escaping (ForecastData?) -> Void) {
        let urlString = "\(baseUrl)/forecast?q=\(city)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let forecastData = try JSONDecoder().decode(ForecastData.self, from: data)
                completion(forecastData)
            } catch {
                print("Failed to decode forecast data: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
