# Coin Radar
## Screenshots

<img src="ReadmeImages/CoinRadar.gif" width="414" height="896">


## About
Coin Radar is a cryptocurrency-related app. This app provides the user with coin statistics and market data. The user can also save his portfolio.   


## Features
- Shows market data -> Market cap, Last 24 hours market volume, Bitcoin dominance.
- Shows coin's data -> Last week price graph, Price, Market cap, Description, Related links, Block time, Hashing algorithm.
- portfolio -> Shows portfolio value, Shows portfolio assets, Save user assets.
- Haptic feedback to alarm user.
- Store coin images in file manager.
- Darkmode 


## Platform 
This app is developed for both iPhone and iPad(only Portrait mode is supported). The target os version is iOS 15.2 and above.



## Architecture
The code is powered by MVVM architecture and usage of frameworks that as follows:
- **SwiftUI:** The app main UI framework is SwiftUI. 
- **Combine:** Combined is used to manage networking and events. 
- **CoreData:** CoreData is used to store user portfolio data.
- **UIKit:** UIkit is used rarely for the purpose of using it's UIElements where SwiftUI can't provide us with the answer.
- **Foundation**

Currently there are 4 main layers and two extra directories:

<mark>Layers are:</mark>
- **Model:** They model structs and classes are responsible for the managing(initialization and updating the objects). Whenever needed they also conform to Codable protocol to encode and decode the objects.

- **View:** Views are mostly only responsible for showing UI elements and animations. In the current version, there are instances that view is responsible for its element's actions and updating data(this is going to be change in future versions).

- **ViewModel:** ViewModels are responsible to provide their relative views with the needed data. They interact with Services and get the data from them and pass the values to their views.

- **Services:** Services are responsible to provide the ViewModels with needed data(from API Call, local database and local file manager).

<mark>Extra Directories are:</mark>
- **Resources:** This directory holds the CoreData Containers and Assets folder
- **Utils**: Utils is the directory that all the helping code implementations are stored in it.


# Documentation
The given description is succint as much as possible. View descriptions are only limited to cases which are out of ordinary implementation or have some important points.


## Model
The model layer constitutes the gateway to the data that are shown in the app. They are created based on the API JSON response. They conform to Codeable protocol(responsible for coding and encoding). Initialization and updating the objects are done in their structs.
### Coin

--
### Statistic
--
### MarketData
--
### CoinDetaileData


## View
### CoinRadarApp
--
### Lunch 
--
### Components -> CircleButton
### Components -> CircleButtonAnimation
### Components -> CoinImageView
### Components -> SearchBarView
### Components -> StatisticeView
### Components -> CloseButton
### Components -> CoinLogoView
--
### Home -> HomeView
### Home -> HomeStatView
### Home -> CoinRowView
### Home -> PortfolioView
--
### Detail -> DetailView
### Detail -> ChartView
--
### Settings -> SettingView



## ViewModels
### Components -> CoinImageViewModel
--
### Home -> HomeViewModel
--
### Detail -> DetailViewModel
--
### Settings -> SettingViewModel


## Services
### CoreDataServices -> PortfolioDataService
--
### APIServices -> CoinAPIService
### APIServices -> CoinImageService
### APIServices -> MarketAPIService
### APIServices -> CoinDetailAPIService


## Resources
### CoreData -> PortfolioContainer
--
### Assets 


## Utils 
### Singletons -> DeveloperPreview
### Singletons -> SharedResources
### Singletons -> NetworkManager
### Singletons -> LocalFileManager
### Singletons -> HapticManager
--
### Modifiers -> Frame
--
### Globals -> DeviceAttribtes
--
### Enums -> AppStyle
### Enums -> Device
### Enums -> Errors
### Enums -> SortOptions
--
### Extensions -> Color
### Extensions -> View
### Extensions -> PreviewProvider
### Extensions -> Double
### Extensions -> UIAplication
### Extensions -> Date
### Extensions -> String  








# Links

[API](https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h)
[API Website](https://www.coingecko.com/en/api)

[Tutorial Github page](https://github.com/SwiftfulThinking)


# Tools
[Convert JSON data to Swift Model](https://app.quicktype.io/)





## Tasks
- [ ] Check how much bandwich each download uses
- [ ] Create a error system
- [ ] Add a Repository level between Services and ViewModels
- [ ] Remove by swiping 
- [x] The pull down functionality(for coin lists)
- [ ] Find another view to make the Coin cell view clickable (currenctly is with background color)
- [ ] Protocol for API Service and put all the API Links there 
- [ ] Show Error for network problems
- [ ] Downloading All coins 
- [ ] Decimal keyboard on Ipad
- [ ] Default background modifier
- [ ] Architecture improvements: Protocols, dependency injection
