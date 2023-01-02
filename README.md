# MovieSearchApp

- Contributor: [grumpy-sw](https://github.com/grumpy-sw)
- Period: 2022.12.16 ~ 2022.12.26

### Index
- [About](#about)
- [Running](#running)
- [Development](#development)
- [Structures](#structures)
- [Trouble Shootings](#trouble-shooting)

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

___

### Structures

#### Dependency direction
<img src="https://user-images.githubusercontent.com/63997044/210256186-f20439ec-0b1c-43c4-8cee-e86c66a531aa.png" width="650">

Clean Architecture의 원칙대로 내부 비즈니스 로직에 해당하는 Domain Layer는 다른 외부 Layer에 의존성을 가지지 않아야 한다.
프레젠테이션, 데이터 영역은 도메인 영역에 대한 의존성을 가진다. 도메인 영역은 같은 도메인 영역에 대한 의존성만을 가진다.

#### View Relation
<img width="638" alt="스크린샷 2023-01-03 오전 5 09 02" src="https://user-images.githubusercontent.com/63997044/210274516-bf566fba-5f6a-4c56-83a4-62370a2fb0a1.png">

앱의 화면은 메인 화면, 검색 결과 화면, 상세 화면으로 구성된다.
- 메인 화면은 검색 결과 화면, 상세 화면으로 이동할 수 있다.
- 검색 결과 화면에서 상세 화면으로 이동할 수 있다.
- 상세 화면은 다른 상세 화면으로 이동할 수 있다.
- 각 View Controller끼리는 FlowCoordinator에 의해 관리된다.

#### Data Flow
<img src="https://user-images.githubusercontent.com/63997044/210256180-786318d2-0c22-43f2-acbb-108b9889c8f6.png" width="650">

1. View가 이벤트를 수신하면 ViewModel은 메서드를 호출한다.
2. ViewModel은 Use Case의 메서드를 호출한다.
3. Use Case는 Repository의 메서드를 호출한다.
4. Repository는 API Provider, Image Provider를 통해 서버에 요청을 보낸다. 받은 응답을 변환하여 다시 Use Case에 응답으로 보낸다.
5. Use Case는 View Model에 데이터를 전달한다.
6. View Model은 호출 결과를 통해 View를 업데이트한다.
___

### Trouble Shooting
- NavigationItem에 Search Bar를 넣는 방법
    - 처음엔 UISearchBar를 사용했으나 오른쪽의 검색 버튼과 Cancel 버튼을 배치하기 때문에 SearchBar의 width를 조절하는 문제가 있어 UISearchController를 사용하였다.
    - searchController.searchBar 프로퍼티로 기존 UISearchBar를 사용할 때의 프로퍼티와 메서드를 사용할 수 있었다.
    - 메서드를 통해 검색, 취소에 대해 NavigationItem을 변경한다.
    
    ```swift
    @objc private func showSearchBar() {
        title = nil
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.rightBarButtonItem = cancelSearchButton
    }
        
    @objc private func hideSearchBar() {
        title = Constants.titleText
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = searchIconButton
    }
    ```
    
- MoviesListView에서 검색을 다시 했을 때 화면을 갱신하는 방법
    - 검색 버튼을 눌렀을 때 항상 첫 페이지를 조회하게 된다.
    - 검색 요청이 첫 페이지일 경우 항상 configureInitialSnapshot 메서드를 호출하여 스냅샷을 초기화하고 다시 등록한다
    
    ```swift
    private func configureInitialSnapshot(with movies: [MovieCard]) {
        currentSnapshot = Snapshot()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(movies)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    ```
    
- 최하단까지 scroll이 되었을 때 추가적으로 다음 페이지의 데이터를 요청하여 화면에 추가하는 방법
    - UICollectionView의 delegate method인 willDisplayCell 메서드를 사용했다.(RxCocoa의 메서드 사용)
    - ViewModel은 화면에 표시될 Cell의 Index를 전달받는다. 우선 다음 페이지가 더 있는지 확인하고 Data Source의 개수보다 4개 적은 Cell이 화면에 보여질 때 미리 추가로 데이터를 요청하여 사용자에게 끊기지 않고 부드럽게 보여지게 했다.
    
    ```swift
    func willDisplayCell(at index: Int) {
        guard hasMorePages else {  // 추가적으로 로드할 데이터가 있는지 확인
            return
        }
        
        // 화면에 보여질 index가 현재의 최대 길이 - 4이고, 현재 로딩중이지 않을 때 데이터 요청
        if index > queriedMovies.value.count - 4, !isLoading {
            currentPage += 1
            moviesListFetching.accept(.nextPage)  // 추가되는 데이터가 nextPage임을 나타냄
            fetchMoviesList(by: query)
        }
    }
    ```
    
    - Data Source가 업데이트되면 View Controller는 appendSnapshot 메서드를 호출하여 현재 스냅샷에 추가된 데이터들의 스냅샷을 append한다.
    
    ```swift
    private func appendSnapshot(with movies: [MovieCard]) {
        // 1 페이지 = 최대 20개. 데이터가 추가되었다면 len > 20이므로 추가된 데이터의 시작 위치는 20, 40, 60...
        let appendItems = Array(movies[((currentPage - 1) * 20)..<movies.count])
        currentSnapshot.appendItems(appendItems, toSection: .main)
            
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    ```
    
- MovieDetailView를 구성하는 방법
    - MovieDetailView는 많은 양의 정보를 다양한 레이아웃으로 보여주고 있다.
    - 방법 1: 단일 UICollectionView와 SupplementaryView를 활용한 방법
        - CompositionalLayout을 사용하면 단일 UICollectionView를 사용하여 하나의 화면을 구성할 수 있다. 그러나 SupplementaryView는 보통 Header와 Footer를 위해 사용되고 다른 정보를 표시하기 위해 사용하는 것은 취지에 맞지 않다고 생각하여 이 방법을 사용하지 않았다.
    - 방법 2: UIScrollView를 통한 View 구성 방법
        - UIScrollView를 사용하면 View의 요소들을 나누어 UIScrollView의 내부에 배치해야 한다. 이때 문제점은 요소들의 고정적인 Height를 지정하지 않으면 Constraints가 제대로 해결되지 않아 화면에 컨텐츠가 나타나지 않았다.
        - 성격이 전혀다른 View의 요소들을 배치하기 위해선 UIScrollView를 통해 구성하는 방법이 맞다고 생각했고 동적인 높이 설정이 필요한 경우(ProductionCompany, Crew) Data Source들의 개수에 따라 UIScreen.main.bounds.width(또는 height)를 통해 높이를 재지정하는 방법을 사용하여 해결하였다.
- MovieDetailView에서 scroll 위치에 따라 NavigationBar를 투명하게 하는 방법
    - MovieDetailView의 baseScrollView의 contentOffset.y를 View Model이 관찰한다.
    - View Model은 특정 높이가 되면 View Controller로 이벤트를 전달한다.
    - View Controller는 전달받은 값에 의해 navigationBar의 배경을 투명하게 바꾼다.
    
    ```swift
    private func setNavigationBar(_ isHidden: Bool) {
        if isHidden {
            setNavigationBarTransparently()
        } else {
            setNavigationBarOpaquely()
        }
    }
        
    private func setNavigationBarTransparently() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
        
    private func setNavigationBarOpaquely() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    ```
