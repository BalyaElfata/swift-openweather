# Swift OpenWeather

Swift OpenWeather is an iOS application that provides weather information and forecasts for various cities. The app is built using Swift and SwiftUI, and it integrates with the OpenWeatherMap API to fetch weather data.

## Features

- **Current Weather**: Displays the current weather conditions for a selected city.
- **5-Day Forecast**: Provides a 5-day weather forecast with daily summaries.
- **Province and City Selection**: Allows users to select their province and city in Indonesia to get localized weather information.
- **Network Monitoring**: Monitors network connectivity and handles errors gracefully with different kinds of alerts.

## Project Structure

The project is organized into the following main directories:

- **Assets.xcassets**: Contains the app's assets, including icons and colors.
- **Data**: Contains the data models, repositories, and services for fetching weather and region data.
- **Presentation**: Contains the SwiftUI views and view models for the app's user interface.

## Key Files

- `WeatherService.swift`: Handles fetching current weather and forecast data from the OpenWeatherMap API.
- `RegionService.swift`: Fetches province and city data from a region API.
- `HomeViewModel.swift`: Manages the state and logic for the home screen.
- `HomeView.swift`: The main view displaying current weather and forecast information.
- `FormViewModel.swift`: Manages the state and logic for the form screen where users select their province and city.
- `FormView.swift`: The view for the form screen.
- `NetworkManager.swift`: Monitors network connectivity and handles errors with different kinds of alerts.

## Dependencies

- **SwiftUI**: Used for building the user interface.
- **Combine**: Used for managing asynchronous data streams and state.

## Setup

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/Swift_OpenWeather.git
    ```
2. Open the project in Xcode:
    ```sh
    cd Swift_OpenWeather
    open Swift_OpenWeather.xcodeproj
    ```
3. Set up your OpenWeatherMap API key:
    - Add your API key to the environment variables in Xcode.

4. Build and run the project on your simulator or device.

## Usage

1. Launch the app.
2. Enter your name and select your province and city in Indonesia.
3. View the current weather and 5-day forecast for your selected city.

## Error Handling

The app includes robust error handling for network and API errors. Different kinds of alerts are shown to the user based on the type of error encountered, ensuring a smooth user experience even when issues arise.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [OpenWeatherMap](https://openweathermap.org/) for providing the weather API.
- [Wilayah.id](https://wilayah.id/) for providing the region data API.
