import Foundation

struct CityData: Codable {
    let data : [City]
}

struct City: Codable {
    let name : String
}
