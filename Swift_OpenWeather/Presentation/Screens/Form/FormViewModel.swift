import Combine
import SwiftUI

class FormViewModel: ObservableObject {
//    @Published var provinces: [String] = []
//    @Published var cities: [String] = []
    @Published var selectedProvince: String = "Pilih Provinsi"
    @Published var selectedCity: String = "Pilih Kota"
    @Published var searchText = ""
    @Published var name: String = ""
    @Published var isValid: Bool = false
    @Published var navigateToHome: Bool = false
    
    @Published var isSelectingProvince: Bool = false
    @Published var isSelectingCity: Bool = false
    
    @Published var provinceData: ProvinceData? = nil
    @Published var cityData: CityData? = nil
    @Published var provinces: [Province] = []
    @Published var cities: [City] = []
    @Published var province: Province?
    @Published var city: City?
    @Published var provinceCode: String = ""
    
    private let regionService = RegionService()

//    private var provinceCityMapping: [String: [String]] = [:]
//    private var cancellables = Set<AnyCancellable>()

//    init() {
//        loadProvincesAndCities()
//    }

//    private func loadProvincesAndCities() {
//        provinceCityMapping = [
//            "Jawa Barat": ["Bandung", "Bogor", "Bekasi"],
//            "DKI Jakarta": ["Jakarta Utara", "Jakarta Barat", "Jakarta Selatan"],
//            "Jawa Tengah": ["Semarang", "Solo", "Yogyakarta"]
//        ]
//
//        provinces = provinceCityMapping.keys.sorted()
//    }

    func getProvinces() async throws {
        do {
            provinces = try await regionService.getProvinces().data
            return
        } catch RegionError.invalidURL {
            print("Invalid region URL")
        } catch RegionError.invalidResponse {
            print("Invalid region response")
        } catch RegionError.invalidData {
            print("Invalid region data")
        } catch {
            print("Unexpected region error: \(error.localizedDescription)")
        }
    }
    
    func getCities() async throws {
        do {
            cities = try await regionService.getCities(provinceCode: provinceCode).data
            return
        } catch RegionError.invalidURL {
            print("Invalid region URL")
        } catch RegionError.invalidResponse {
            print("Invalid region response")
        } catch RegionError.invalidData {
            print("Invalid region data")
        } catch {
            print("Unexpected region error: \(error.localizedDescription)")
        }
    }
    
//    func cities(for province: String) -> [String] {
//        return provinceCityMapping[province] ?? []
//    }

//    func validateInputs(name: String, province: String, city: String) -> Bool {
//        return !name.isEmpty && !province.isEmpty && !city.isEmpty
//    }
    
    func validateForm() {
        isValid = !name.isEmpty && selectedProvince != "Pilih Provinsi" && selectedCity != "Pilih Kota"
    }
}
