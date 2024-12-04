import Foundation

struct ProvinceData: Codable {
    let data : [Province]
}

struct Province: Codable {
    let code : String
    let name : String
    
    init(from provinceData: ProvinceData) {
        self.code = provinceData.data.first?.code ?? ""
        self.name = provinceData.data.first?.name ?? ""
    }
}
