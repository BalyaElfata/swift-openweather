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
                    .textInputAutocapitalization(.words)
                
                CustomPicker(type: .province, options: viewModel.provinces.map{$0.name})
                        .environmentObject(viewModel)
                CustomPicker(type: .city, options: viewModel.cities.map{$0.name})
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
            .sheet(isPresented: $viewModel.isSelectingProvince, content: {
                OptionsList(type: .province, options: viewModel.provinces.map{$0.name})
                    .environmentObject(viewModel)
            })
            .sheet(isPresented: $viewModel.isSelectingCity, content: {
                OptionsList(type: .city, options: viewModel.cities.map{$0.name})
                    .environmentObject(viewModel)
            })
            .task {
                do {
                    try await viewModel.getProvinces()
                } catch {
                    print("Error catching data")
                }
            }
            .onChange(of: viewModel.name) { viewModel.validateForm() }
            .onChange(of: viewModel.selectedProvince) {
                viewModel.selectedCity = "Pilih Kota"
                Task {
                    try await viewModel.getCities()
                }
                viewModel.validateForm()
            }
            .onChange(of: viewModel.selectedCity) { viewModel.validateForm() }
        }
    }
}

#Preview {
    FormView()
}
