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
                Section(header: Text("Cuaca Hari Ini")) {
                    if let weather = viewModel.currentWeather {
                        Text("Kota: \(weather.location)")
                        Text("Temperatur: \(weather.temperature.formatted(.number.rounded(increment: 1.0)))°C")
                        Text("Cuaca: \(viewModel.translateWeather(weather:weather.condition))")
                    }
                }
                
                Section(header: Text("Cuaca 5 hari ke depan")) {
                    if $viewModel.forecast.isEmpty {
                        Text("Loading...")
                    } else {
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
                                            .frame(width: 130, height: 70)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 130, height: 70)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 130, height: 70)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
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
