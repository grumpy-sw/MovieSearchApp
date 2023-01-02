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

![Xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)
![iOS](https://img.shields.io/badge/iOS-15-lightgrey)
![Swift](https://img.shields.io/badge/Swift-5-orange)

Libraries

![SnapKit](https://img.shields.io/badge/SnapKit-5.6.0-success)
![Then](https://img.shields.io/badge/Then-3.0.0-blue)
![RxSwift](https://img.shields.io/badge/RxSwift-6.5.0-blueviolet)
![RxCocoa](https://img.shields.io/badge/RxCocoa-6.5.0-ff69b4)
![Quick](https://img.shields.io/badge/Quick-6.1.0-orange)
![Nimble](https://img.shields.io/badge/Nimble-11.2.1-red)

API Server

![](https://i1.daumcdn.net/thumb/C264x200/?fname=https://blog.kakaocdn.net/dn/brgtr3/btqLWJew0XS/qm2txLSbhQxwXokURDd1Z1/img.png)

___

### Structures

#### Dependency direction
<img src="https://user-images.githubusercontent.com/63997044/210256186-f20439ec-0b1c-43c4-8cee-e86c66a531aa.png" width="650">

The main rule of Clean Architecture is not to have dependencies from inner layers to outer layers.
The Presentation and Data layers is dependent on the Domain layer, which is the internal business logic.

#### View Relation
<img width="638" alt="스크린샷 2023-01-03 오전 5 09 02" src="https://user-images.githubusercontent.com/63997044/210274516-bf566fba-5f6a-4c56-83a4-62370a2fb0a1.png">

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
