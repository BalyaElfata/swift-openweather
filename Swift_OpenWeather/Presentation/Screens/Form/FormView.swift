import SwiftUI
import SwiftData

struct FormView: View {
    @StateObject private var viewModel = FormViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Nama Lengkap", text: $viewModel.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textFieldStyle(.roundedBorder)
                
                SearchableDropdown(type: .province, options: viewModel.provinces)
                    .environmentObject(viewModel)
                
                SearchableDropdown(type: .city, options: viewModel.cities(for: viewModel.selectedProvince))
                    .environmentObject(viewModel)
                
                Button("Proses") {
                    if viewModel.isValid {
                        viewModel.navigateToHome = true
                    } else {
                        // Show validation error
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isValid)
            }
            .padding()
            .navigationTitle("Pengisian Data")
            .navigationDestination(isPresented: $viewModel.navigateToHome, destination: {
                HomeView(name: $viewModel.name, city: $viewModel.selectedCity)
            })
            .onChange(of: viewModel.name) { viewModel.validateForm() }
            .onChange(of: viewModel.selectedProvince) {
                viewModel.selectedCity = "Pilih Kota"
                viewModel.validateForm()
            }
            .onChange(of: viewModel.selectedCity) { viewModel.validateForm() }
        }
    }
}

#Preview {
    FormView()
}
