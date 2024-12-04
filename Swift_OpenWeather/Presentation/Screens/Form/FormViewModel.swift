import Combine
import SwiftUI

class FormViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var name: String = ""
    @Published var isValid: Bool = false
    @Published var navigateToHome: Bool = false
    
    @Published var isSelectingProvince: Bool = false
    @Published var isSelectingCity: Bool = false
    @Published var selectedProvince: String = "Pilih Provinsi"
    @Published var selectedCity: String = "Pilih Kota"
    @Published var provinceCode: String = ""
    
    @Published var provinceData: ProvinceData? = nil
    @Published var cityData: CityData? = nil
    @Published var provinces: [Province] = []
    @Published var cities: [City] = []
    
    private let regionService = RegionService()

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
    
    func validateForm() {
        isValid = !name.isEmpty && selectedProvince != "Pilih Provinsi" && selectedCity != "Pilih Kota"
    }
}
