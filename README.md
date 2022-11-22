
![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![Languages](https://img.shields.io/badge/Language-Swift-orange.svg)

iOS code challange.

## Demo
<img src="https://media.giphy.com/media/ZyTPecpbhgerWXf5IO/giphy.gif" width="222" height="480" />

## Features

- [x] Implemented using MVVM-C with DIContainers and Repository
- [x] Network Requests using URLSession
- [x] HTTP Response Validation
- [x] Image Caching
- [x] Unit Tests
- [x] UI Tests
- [x] Zero warnings
- [x] No Dependencies

## Requirements

- iOS 15.0+
- Xcode 13.4+
- Swift 5+

## Design Pattern: Model-View-ViewModel Coordinator (MVVM - C)
is a structural design pattern that separates objects into three distinct groups:
- #### Model 
  - Contains the data models of the application
- #### View
  - View layer contains the UI (UIViewController).
- #### ViewModel
  - The communication layer between model and views. It also contains the business logic.
- ### Coordinator
  - Implemented coordinator pattern for the navigation in the application.
  
- ### Coding flow
    - ViewController -> ViewModel -> Repository -> NetworkLayer.
    

## Installation

### Clone Or Download Repository

- Clone the project and open 'DogBreeds.xcodeproj'.
