import SwiftUI
import SwiftData

struct FormView: View {
    @State var name: String = ""
    @State private var selectedProvince: String = ""
    @State var selectedCity: String = ""
    @State private var isValid: Bool = false
    @State private var navigateToHome: Bool = false
    @ObservedObject private var viewModel = FormViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Nama Lengkap", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Text("Pilih Provinsi:")
                    Picker("Pilih Provinsi", selection: $selectedProvince) {
                        ForEach(viewModel.provinces, id: \.self) { province in
                            Text(province).tag(province)
                        }
                    }
                }
                
                if !selectedProvince.isEmpty {
                    HStack {
                        Text("Pilih Kota:")
                        Picker("Pilih Kota", selection: $selectedCity) {
                            ForEach(viewModel.cities(for: selectedProvince), id: \.self) { city in
                                Text(city).tag(city)
                            }
                        }
                    }
                }
                
                Button("Proses") {
                    if viewModel.validateInputs(name: name, province: selectedProvince, city: selectedCity) {
                        navigateToHome = true
                    } else {
                        // Show validation error
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isValid)
            }
            .padding()
            .navigationDestination(isPresented: $navigateToHome, destination: {
                HomeView(name: $name, city: $selectedCity)
            })
            .onChange(of: name) { validateForm() }
            .onChange(of: selectedProvince) { validateForm() }
            .onChange(of: selectedCity) { validateForm() }
        }
    }

    private func validateForm() {
        isValid = !name.isEmpty && !selectedProvince.isEmpty && !selectedCity.isEmpty
    }
}

#Preview {
    FormView()
}
