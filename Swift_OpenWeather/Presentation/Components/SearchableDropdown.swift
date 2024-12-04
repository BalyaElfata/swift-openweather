import SwiftUI

struct SearchableDropdown: View {
    @EnvironmentObject var viewModel: FormViewModel
    @EnvironmentObject var networkManager : NetworkManager
    var type: DropdownType
    let options: [String]

    var body: some View {
        NavigationStack {
            VStack {
                if networkManager.isConnected == false {
                    ContentUnavailableView("Network Error", systemImage: "wifi.slash", description: Text("Koneksi Error. Cek kembali koneksi anda dan ulangi."))
                } else if $viewModel.provinces.isEmpty {
                    ContentUnavailableView("API Error", systemImage: "wifi.exclamationmark", description: Text("Error mengambil data \(type == .province ? "provinsi" : "kota") dari API."))
                } else if searchResults.isEmpty {
                    ContentUnavailableView("Tidak Ada Hasil Pencarian", systemImage: "magnifyingglass", description: Text("Cek ejaan dari \(type == .province ? "provinsi" : "kota") atau coba pencarian baru."))
                } else {
                    List {
                        ForEach(searchResults, id: \.self) { option in
                            Button {
                                if type == .province {
                                    viewModel.selectedProvince = option
                                    viewModel.provinceCode = viewModel.provinces.first(where: { $0.name == viewModel.selectedProvince })?.code ?? ""
                                    viewModel.isSelectingProvince = false
                                } else {
                                    viewModel.selectedCity = String(option.dropFirst(5))
                                    viewModel.isSelectingCity = false
                                }
                            } label: {
                                Text(option)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
        }
    }

    var searchResults: [String] {
        if viewModel.searchText.isEmpty {
            return options
        } else {
            return options.filter { $0.contains(viewModel.searchText) }
        }
    }
}

#Preview {
    SearchableDropdown(type: .province, options: ["Holly", "Josh", "Rhonda", "Ted"])
        .environmentObject(FormViewModel())
        .environmentObject(NetworkManager())
}
