import SwiftUI

struct SearchableDropdown: View {
    @EnvironmentObject var viewModel: FormViewModel
    var type: DropdownType
    let options: [String]

    var body: some View {
        NavigationStack {
            if $viewModel.provinces.isEmpty {
                ContentUnavailableView("Error", systemImage: "exclamationmark.circle", description: Text("Error mengambil data provinsi. Cek kembali koneksi anda dan ulangi."))
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
                .searchable(text: $viewModel.searchText)
            }
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
}
