# Coin Radar
## Screenshots

<img src="ReadmeImages/CoinRadar.gif" height="500">


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
The given description is as succinct as possible. View descriptions are limited to cases that are out of ordinary implementation or have some important points. Repetitive implementations, are mentioned only in the first documented file.


## Model
The model layer constitutes the gateway to the data that are shown in the app. They are created based on the API JSON response. They conform to Codeable protocol(responsible for coding and encoding). Initialization and updating the objects are done in their structs.

### Coin
**Conformances protocols**
Coin model conforms both to [Identifiable](https://developer.apple.com/documentation/swift/identifiable) and [Codeable](https://developer.apple.com/documentation/swift/codable) protocols. 

Codeable protocol basically converts this struct's objects to JSON data in oreder to be sent to a API and it also decode the JSON data recieved from a API call to a object of this type. 

Identifiable gives our data model a unique id so a object would be distinguishable from all other objects of this type.

**CodingKeys enum**
Encoding and decoding the data to and from this struct is possible through the implmentation of CodingKeys which is a enum that confroms to String and [CodingKey](https://developer.apple.com/documentation/swift/codingkey) protocol. This enum holds all the struct model's attributes and their relative string value in API call.(It is required if you want to conform to Codeable protocol)

```swift
struct Coin: Identifiable, Codable {
    let id: String
    let currentPrice: Double
    .
    .
    .

    enum CodingKeys: String, CodingKey {
        case id
        case currentPrice = "current_price"
        .
        .
        .
    }
}
```

We can have "currenPrice" attribute in our data model which we want to be encoded to JSON data that its relative key is "current_price". So we simply use CodingKey enum for this purpose.(If the attribute in our data model and the JSON key are the same we can simply omit givving them any string value.)

**Attributes**
This struct model is created based on the [APIURL](https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h). I decided to alter some of the fields in both the struct attributes and the coding keys because I simply didn't want to show the data provided with those attributes. 

**updateHoldings function**
The coin data model has a function for the purpose of updating the user portfolio(updaing user holding currencies). This function is then used whenever the user want to add a new currecny to his portfolio or update his old holdings.

**currentHoldingsValue computed property**
The user normally hasn't all the existing coins in his portfolio so based on the ammount that user holds(which is stored in the "currentHoldings" field) a coin and the coin price at a time this "currentHoldingValue" field is changed and calculated.

**rank computed property**
Each coin object's rank is determined by its market capitalization.

**SparklineIn7D struct**
This struct holds an array of price changes for each coin object.

---
### CoinDetaileData
**Attributes**
This model is created based on the [APIURL]( https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false). Not all the API JSON response are included in this data. 

**readableDescription computed property**
```swift
    var readableDescription: String?{
        description?.en?.removingHTMLOccurances
    }

```
description field that its values is coming from the API response, contains HTML codes and isn't proper to be shown to the user. "removingHMLOccurances" is a computed property, implemented in the String Extension(you can find it below) that remove all the HTML-related characters from a string and returns the readable string.

**Links struct**
Holds a coin's website and its Subredit link if it existed.

**Description struct**
Holds a coin's description if there is one.

---
### MarketData
**Attributes**
This model is created base on the [APIURL](https://api.coingecko.com/api/v3/global). Not all the API JSON response fields are included in this data model.

**marketCap computed property**
If total-market-cap data is available then this attribute returns formatted String abbreviation of that data.

**volume computed property**
If total voulme is available then this attribute returns formatted string abbreviation of that data.

**btcDom computed property**
This attribute retrurns Bitcoin dominance as a string.

**NOTE**
By default all the data are shown in USD.

---
### Statistic
**Attributes**
This model is created based on the needs to show data on the screen. This model is specifically designed for StaticView. You can see statistics in detail view and Main View Bitcoin Dominance and ... . 

**Initializer**
This data model has a custom initializer because not all the Statistic Views have percentage string.


## View
### CoinRadarApp
**showLunchView Attribute**
It is a state variable which based on its value CoinRadarApp decides to whther shows the lunch screen animation or the app Home view.

**viewModel Attribute**
It is a StateObject that is sent to the Home View as an environment object. The reason of sending it as an environment object is convenience. In this way all Child Views of HomeView can access this ViewModel through environment object. This object is referenced within HomeStatView and PortfolioView as well as in HomeView.

**Initializer**
This view's initializer is responsible for some of global view configurations such UINavigationBar text color and etc. 

**Note:**
Navigation View is implemented here so all the child views would inherit it. 

**Scene Body**
Because we want to be sure that the lunch animation in Lunchview is being presented infront all Views we gave it zIndex value.

---
### Lunch 
**Description**
Due to limitation of LunchScreen in info plist which is the prefered way to use lunch screens by apple in SwiftUI, this app is using UIKIt Lunch screen. The lunch screen is a black view with the logo at the center. The animation in lunch screen is implemented in LunchView.


**main Body**
The main body presnets the app logo and loading animation.

**Animation**
The loading animation is a simple Time-publisher based. The animating text is achieved by creating a HStack of Loading string and applying y offset on specific string character in each 0.1 seconds. There is also a transition effect on inserting the view on the screen. The loading animitation si initialized by toggling a state variable that is changed to true on onAppear call. 

As mentioned the animation is based on a time publisher which pulish each 0.1 second on the main queue the timer is used call the block code that manages the animation. Time published value is recieved on onReceive call. 

There is counter that will be increamented on each new published value and then animation will be applied to corresponding index in the HStack of strings. The counter will be reset to zero if it reaches the loading string lenth count. 

---
### LunchView

---
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
