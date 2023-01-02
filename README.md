# MovieSearchApp

- Contributor: [grumpy-sw](https://github.com/grumpy-sw)
- Period: 2022.12.16 ~ 2022.12.26

### Index
- [About](#about)
- [Running](#running)
- [Development](#development)
- [Structures](#structures)

### About
#### Using TMDB API
Toy Project For Practicing **URLSession**, **MVVM**, **Clean Architecture**, **RxSwift**
___

### Running

|MainView|Search Movie|Load More Pages|
|------|---|---|
|<img src="https://user-images.githubusercontent.com/63997044/210161252-df63b764-8d80-482d-a42b-dc89c5b5dfac.gif" width="200" height="400">|<img src="https://user-images.githubusercontent.com/63997044/210161254-cd095705-8ce2-4c0e-b046-cf2d34a949aa.gif" width="200" height="400">|<img src="https://user-images.githubusercontent.com/63997044/210161256-3867f20d-3428-4259-b902-081ce4f5ac31.gif" width="200" height="400">|

|MovieDetailView|Recommendations|
|------|---|
|<img src="https://user-images.githubusercontent.com/63997044/210161292-0e06c373-545b-4ad3-91ac-808e651e82f1.gif" width="200" height="400">|<img src="https://user-images.githubusercontent.com/63997044/210161294-73c469e6-de9d-406e-8699-6fcaa20262c5.gif" width="200" height="400">|
___

### Development
Environments
- Xcode 13.4.1
- iOS 15(iOS 12+)
- Swift 5

Libraries
- SnapKit
- Then
- RxSwift
- RxCocoa
- Quick
- Nimble
___

### Structures

#### Dependency direction
<img src="https://user-images.githubusercontent.com/63997044/210256186-f20439ec-0b1c-43c4-8cee-e86c66a531aa.png" width="650">

The main rule of Clean Architecture is not to have dependencies from inner layers to outer layers.
The Presentation and Data layers is dependent on the Domain layer, which is the internal business logic.

#### View Relation
<img src="https://user-images.githubusercontent.com/63997044/210256189-fd0baa78-b6b4-47b5-90c7-b1e06070ffa2.png" width="300">

- MainView can move to MoviesListView and MovieDetailView.
- MoviesListView can move to MovieDetailView.
- MovieDetailView can move to another MovieDetailView.

Each View Controller is managed by present@ViewController and dismiss@ViewController methods of FlowCoordinator.

#### Data Flow
<img src="https://user-images.githubusercontent.com/63997044/210256180-786318d2-0c22-43f2-acbb-108b9889c8f6.png" width="650">

1. When View receives an event, ViewModel calls the method.
2. ViewModel executes Use Case.
3. Use Case executes Repository's method.
4. Repository requests data from the server through API Provider.
5. The data is returned and reaches View again.
