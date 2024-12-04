import Foundation

class RegionService {
    private let provinceUrl = "https://wilayah.id/api/provinces.json"

    func getProvinces() async throws -> ProvinceData {
        
        guard let url = URL(string: provinceUrl) else {
            throw RegionError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RegionError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(ProvinceData.self, from: data)
        } catch {
            throw RegionError.invalidData
        }
    }
    
    func getCities(provinceCode: String) async throws -> CityData {
        let urlString = "https://wilayah.id/api/regencies/\(provinceCode).json"
        
        guard let url = URL(string: urlString) else {
            throw RegionError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RegionError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(CityData.self, from: data)
        } catch {
            throw RegionError.invalidData
        }
    }
}

enum RegionError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
