import Foundation

class WeatherService {
    private let apiKey = "39be9a0b8f3a74ade269205d2bc11fc5"
    private let provinceUrl = "https://wilayah.id/api/provinces.json"

    func getWeather(city: String) async throws -> WeatherData {
        let urlString = "\(baseUrl)/weather?q=\(city)&units=metric&lang=id&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(WeatherData.self, from: data)
        } catch {
            throw WeatherError.invalidData
        }
    }
    
    func getWeatherForecast(city: String) async throws -> ForecastData {
        let urlString = "\(baseUrl)/forecast?q=\(city)&units=metric&lang=id&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(ForecastData.self, from: data)
        } catch {
            throw WeatherError.invalidData
        }
    }
}

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
