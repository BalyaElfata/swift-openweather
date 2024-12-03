import SwiftUI

struct HomeView: View {
    @Binding var name: String
    @Binding var city: String
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.greetingMessage)
                .font(.headline)
            
            Spacer()
            
            if $viewModel.forecast.isEmpty {
                ContentUnavailableView("Error", systemImage: "exclamationmark.circle", description: Text("Error mengambil data cuaca di kota \(city)"))
            } else {
                VStack {
                    if let weather = viewModel.currentWeather {
                        Text(weather.location)
                            .font(.largeTitle)
                            .fontWeight(.medium)
                        
                        Text("\(weather.temperature.formatted(.number.precision(.fractionLength(0))))°C")
                            .font(.system(size: 80))
                            .fontWeight(.light)
                        
                        Text(viewModel.translateWeather(weather:weather.condition))
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                LazyVStack {
                    Text("Forecast Cuaca 5 Hari ke Depan")
                        .textCase(.uppercase)
                    
                    ForEach(viewModel.forecast) { forecast in
                        Divider()
                        
                        HStack {
                            Text(forecast.date)
                            
                            Spacer()
                            
                            Text("\(forecast.temperature.formatted(.number.precision(.fractionLength(0))))°C")
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string:"https://openweathermap.org/img/wn/\(forecast.icon)@2x.png")) { phase in
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
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
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
    HomeView(name: .constant("Balya"), city: .constant("Jakarta"))
}
