# Time Score - Football App

A comprehensive Flutter application for football enthusiasts to search and manage information about players, teams, and competitions using the SofaScore API.

## Features

### 🏠 Home Page
- **Search Functionality**: Search for players, teams, and competitions
- **Navigation Buttons**: Quick access to Map, Favorite Teams, and Favorite Players
- **Real-time Results**: Display search results with detailed information
- **Modern UI**: Beautiful gradient design with card-based layout

### 👤 Player Details
- **Comprehensive Information**: Player stats, position, jersey number, team details
- **Team Information**: Current team, country, sport details
- **Favorite Management**: Add/remove players from favorites
- **Visual Design**: Team colors display and modern card layout

### ⚽ Team Details
- **Team Information**: Name, code, country, sport, user count
- **Squad Display**: View team players with navigation to player details
- **Team Colors**: Visual representation of team branding
- **Favorite Management**: Add/remove teams from favorites

### 🗺️ Interactive Map
- **Football Stadiums**: Pre-loaded stadium locations for major teams
- **Current Location**: GPS integration with user's current position
- **Interactive Markers**: Click to view stadium and team information
- **Zoom Controls**: Easy navigation with zoom in/out functionality

### ❤️ Favorites Management
- **Favorite Players**: View and manage saved players
- **Favorite Teams**: View and manage saved teams
- **Persistent Storage**: Favorites saved locally using SharedPreferences
- **Easy Removal**: Swipe or menu options to remove favorites

## Technical Features

### API Integration
- **SofaScore API**: Real-time football data via RapidAPI
- **Search Endpoints**: Players, teams, and tournaments search
- **Detail Endpoints**: Comprehensive information for each entity
- **Error Handling**: Robust error handling with user feedback

### State Management
- **Provider Pattern**: Efficient state management
- **Local Storage**: SharedPreferences for favorites persistence
- **Async Operations**: Proper loading states and error handling

### UI/UX Design
- **Material Design 3**: Modern Flutter design system
- **Responsive Layout**: Works on various screen sizes
- **Gradient Backgrounds**: Beautiful visual appeal
- **Card-based Design**: Clean and organized information display

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── player.dart          # Player data model
│   └── team.dart            # Team and tournament models
├── pages/
│   ├── home.dart            # Main home page with search
│   ├── player_details.dart  # Player information page
│   ├── team_details.dart    # Team information page
│   ├── map.dart             # Interactive map page
│   ├── favorite_teams.dart  # Favorite teams management
│   └── favorite_players.dart # Favorite players management
└── services/
    ├── api_service.dart     # SofaScore API integration
    └── favorites_service.dart # Local storage for favorites
```

## Dependencies

- **http**: HTTP requests for API calls
- **provider**: State management
- **shared_preferences**: Local storage for favorites
- **google_maps_flutter**: Interactive map functionality
- **geolocator**: Location services
- **permission_handler**: Location permissions
- **cached_network_image**: Image caching (for future use)

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd time_score
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Key**
   - The app uses the SofaScore API via RapidAPI
   - API key is already configured in `lib/services/api_service.dart`
   - For production, consider moving the API key to environment variables

4. **Run the application**
   ```bash
   flutter run
   ```

## API Configuration

The app uses the SofaScore API with the following endpoints:
- Player search: `/players/search`
- Team search: `/teams/search`
- Tournament search: `/tournaments/search`
- Player details: `/players/{id}`
- Team details: `/teams/{id}`
- Team squad: `/teams/{id}/players`

## Features in Detail

### Search Functionality
- **Multi-type Search**: Search for players, teams, or competitions
- **Real-time Results**: Instant search results with loading indicators
- **Detailed Information**: Rich data display for each search result
- **Navigation**: Easy navigation to detailed views

### Map Integration
- **Stadium Locations**: Pre-configured stadium locations for major teams
- **User Location**: GPS integration to show user's current position
- **Interactive Markers**: Click markers for stadium information
- **Zoom Controls**: Built-in zoom functionality

### Favorites System
- **Local Storage**: Favorites saved locally using SharedPreferences
- **Easy Management**: Add/remove favorites with visual feedback
- **Persistent Data**: Favorites remain after app restart
- **Quick Access**: Dedicated pages for favorite management

## Future Enhancements

- **Live Scores**: Real-time match scores and statistics
- **Push Notifications**: Match alerts and updates
- **Social Features**: Share favorite players/teams
- **Advanced Statistics**: Detailed player and team analytics
- **Offline Mode**: Cached data for offline viewing
- **Multiple Languages**: Internationalization support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- **SofaScore API**: For providing comprehensive football data
- **Flutter Team**: For the amazing framework
- **RapidAPI**: For API hosting and management
