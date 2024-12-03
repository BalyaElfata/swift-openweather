import SwiftUI
import SwiftData

struct FormView: View {
    @State var name: String = ""
    @State private var province: String = ""
    @State var city: String = ""
    @State private var isValid: Bool = false
    @State private var navigateToHome: Bool = false
    @StateObject private var viewModel = FormViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Nama Lengkap", text: $name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textFieldStyle(.roundedBorder)
                
                SearchableDropdown(type: .province, options: viewModel.provinces)
                    .environmentObject(viewModel)
                
                SearchableDropdown(type: .city, options: viewModel.cities(for: viewModel.selectedProvince))
                    .environmentObject(viewModel)
                
                Button("Proses") {
                    if viewModel.validateInputs(name: name, province: province, city: city) {
                        navigateToHome = true
                    } else {
                        // Show validation error
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isValid)
            }
            .padding()
            .navigationTitle("Pengisian Data")
            .navigationDestination(isPresented: $navigateToHome, destination: {
                HomeView(name: $name, city: $city)
            })
            .onChange(of: name) { validateForm() }
            .onChange(of: viewModel.selectedProvince) {
                viewModel.selectedCity = "Pilih Kota"
                validateForm()
            }
            .onChange(of: viewModel.selectedCity) { validateForm() }
        }
    }

    private func validateForm() {
        isValid = !name.isEmpty && viewModel.selectedProvince != "Pilih Provinsi" && viewModel.selectedCity != "Pilih Kota"
    }
}

#Preview {
    FormView()
}
