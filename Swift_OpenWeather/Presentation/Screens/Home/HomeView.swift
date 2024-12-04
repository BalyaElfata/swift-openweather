import SwiftUI

struct HomeView: View {
    @Binding var name: String
    @Binding var city: String
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var networkManager : NetworkManager
    
    var body: some View {
        ZStack {
            if !viewModel.forecast.isEmpty {
                LinearGradient(colors: [Color.blue.opacity(0.6), Color.cyan.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            }
            
            VStack() {
                Text(viewModel.greetingMessage)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                if networkManager.isConnected == false {
                    ContentUnavailableView("Network Error", systemImage: "wifi.slash", description: Text("Koneksi Error. Cek kembali koneksi anda dan ulangi."))
                } else if viewModel.currentWeather == nil {
                    ContentUnavailableView("API Error", systemImage: "wifi.exclamationmark", description: Text("Error mengambil data cuaca di kota \(city)."))
                } else if $viewModel.forecast.isEmpty {
                    ContentUnavailableView("API Error", systemImage: "exclamationmark.circle", description: Text("Error mengambil data ramalan cuaca di kota \(city)."))
                } else {
                    VStack {
                        if let weather = viewModel.currentWeather {
                            Text(weather.location)
                                .font(.largeTitle)
                                .fontWeight(.medium)
                            
                            Text("\(weather.temperature.formatted(.number.precision(.fractionLength(0))))°C")
                                .font(.system(size: 60))
                                .fontWeight(.light)
                            
                            Text(viewModel.translateWeather(weather:weather.condition))
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                        VStack {
                            HStack {
                                Image(systemName: "calendar")
                                Text("Ramalan 5 hari")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.subheadline)
                                    .textCase(.uppercase)
                            }
                            
                            ForEach(viewModel.forecast) { forecast in
                                Divider()
                                
                                HStack {
                                    Text(forecast.date)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    Text("\(forecast.temperature.formatted(.number.precision(.fractionLength(0))))°C")
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    AsyncImage(url: URL(string:"https://openweathermap.org/img/wn/\(String(forecast.icon.dropLast(1)))d@2x.png")) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 60, height: 60)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 60)
                                        case .failure:
                                            Image(systemName: "exclamationmark.triangle")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(Color.secondary)
                                                .padding(12)
                                                .frame(width: 60, height: 60)
                                        @unknown default:
                                            Image(systemName: "exclamationmark.triangle")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(Color.secondary)
                                                .padding(12)
                                                .frame(width: 60, height: 60)
                                        }
                                    }
                                    
                                    Text(viewModel.translateWeather(weather:forecast.condition))
                                        .fontWeight(.medium)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.white)
                        )
                        .padding(.horizontal)
                    }
                
                Spacer()
            }
        }
        .task {
            do {
                try await viewModel.getWeatherData()
                try await viewModel.getForecastData()
            } catch {
                print("Error catching data")
            }
        }
        .onAppear {
            viewModel.name = name
            viewModel.city = city
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(name: .constant("Balya Elfata"), city: .constant("Tangerang"))
            .environmentObject(NetworkManager())
    }
}
