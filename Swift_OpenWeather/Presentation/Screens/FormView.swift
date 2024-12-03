import SwiftUI
import SwiftData

struct FormView: View {
    @State var name: String = ""
    @State private var province: String = ""
    @State var city: String = ""
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
                    Picker("Pilih Provinsi", selection: $province) {
                        ForEach(viewModel.provinces, id: \.self) { province in
                            Text(province).tag(province)
                        }
                    }
                }
                
                if !province.isEmpty {
                    HStack {
                        Text("Pilih Kota:")
                        Picker("Pilih Kota", selection: $city) {
                            ForEach(viewModel.cities(for: province), id: \.self) { city in
                                Text(city).tag(city)
                            }
                        }
                    }
                }
                
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
            .navigationDestination(isPresented: $navigateToHome, destination: {
                HomeView(name: $name, city: $city)
            })
            .onChange(of: name) { validateForm() }
            .onChange(of: province) { validateForm() }
            .onChange(of: city) { validateForm() }
        }
    }

    private func validateForm() {
        isValid = !name.isEmpty && !province.isEmpty && !city.isEmpty
    }
}

#Preview {
    FormView()
}
