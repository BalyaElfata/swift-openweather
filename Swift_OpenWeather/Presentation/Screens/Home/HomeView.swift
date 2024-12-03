import SwiftUI

struct HomeView: View {
    @Binding var name: String
    @Binding var city: String
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.greetingMessage)
                .font(.headline)
            
            Form {
                Section {
                    if let weather = viewModel.currentWeather {
                        Text("Kota: \(weather.location)")
                        Text("Temperatur: \(weather.temperature.formatted(.number.precision(.fractionLength(1))))°C")
                        Text("Cuaca: \(viewModel.translateWeather(weather:weather.condition))")
                    }
                }
                
                Section {
                    if $viewModel.forecast.isEmpty {
                        Text("Loading...")
                    } else {
                        Text("Forecast Cuaca 5 Hari ke Depan")
                            .textCase(.uppercase)
                        ForEach(viewModel.forecast) { forecast in
                            HStack {
                                Text(forecast.date)
                                
                                Spacer()
                                
                                Text("\(forecast.temperature.formatted(.number.precision(.fractionLength(1))))°C")
                                
                                Spacer()
                                
                                AsyncImage(url: URL(string:"https://openweathermap.org/img/wn/\(forecast.icon)@2x.png")) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 100, height: 100)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                    case .failure:
                                        Image(systemName: "exclamationmark.triangle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        Image(systemName: "exclamationmark.triangle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Text(viewModel.translateWeather(weather:forecast.condition))
                            }
                        }
                    }
                }
            }
        }
        .task {
            do {
                try await viewModel.getWeatherData()
                try await viewModel.getForecastData()
            } catch WeatherError.invalidURL {
                print("Invalid URL")
            } catch WeatherError.invalidResponse {
                print("Invalid response")
            } catch WeatherError.invalidData {
                print("Invalid data")
            } catch {
                print("unexpected error")
            }
        }
        .onAppear {
            viewModel.name = name
            viewModel.city = city
        }
    }
}

#Preview {
    HomeView(name: .constant("Balya"), city: .constant("Jakarta"))
}
