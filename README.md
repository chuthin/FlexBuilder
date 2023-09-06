# FlexBuilder: A Declarative UIKit Library
SwiftUI builder patterns for UIKit implemetation of [Builder](https://github.com/hmlongco/Builder) with [FlexLayout](https://github.com/layoutBox/FlexLayout) and [PinLayout](https://github.com/layoutBox/PinLayout). Support Hot reload with [InjectionIII](https://github.com/johnno1962/InjectionIII)

Install
1. To integrate FlexLayout into an Xcode target, use the `File -> Swift Packages -> Add Package Dependency` menu item.
2. Add "FLEXLAYOUT_SWIFT_PACKAGE=1" to the Xcode target's `GCC_PREPROCESSOR_DEFINITIONS` build setting. (TARGET -> Build Settings -> Apple Clang-Preprocessing -> Preprocessor Macros)


This example is available in the [Examples App](https://github.com/chuthin/FlexBuilder/tree/main/Example).
| | | 
|:-------------------------:|:-------------------------:|
|<img src="https://github.com/chuthin/FlexBuilder/assets/4926746/62abf177-d461-4042-ac30-7b38ed575a6c" width="300"/>|<img src="https://github.com/chuthin/FlexBuilder/assets/4926746/2458b7e4-54f0-43dd-88ee-8d0fc6398280" width="300"/>|
</div>

<br>

The example implements the [Ray Wenderlich Yoga Tutorial](https://www.raywenderlich.com/161413/yoga-tutorial-using-cross-platform-layout-engine) screen using FlexLayout.

<br> 

```swift
struct ReywnderlichTutorialController : ControllerBuilder {
    @Variable var showSelected: Show? = nil
    var series = Series()
    func view() -> any BuilderViewController {
        return FViewController {
            FScrollView {
                FVStack {
                    FImage(named: series.image).aspectRatio(16/9).contentMode(.scaleAspectFill).clipsToBounds(true)
                    FVStack {
                        FHStack(space: 4){
                            FText(String(repeating: "★", count: series.showPopularity)).color(.red)
                            FText(series.showYear).color(.lightGray)
                            FText(series.showRating).color(.lightGray)
                            FText(series.showLength).color(.lightGray)
                        }
                        FSpacer()
                        FHStack{
                            FText(series.selectedShow).font(.boldSystemFont(ofSize: 16)).color(.lightGray).margin(.right,20)
                            FText($showSelected.asObservable().map{$0?.title}).font(.boldSystemFont(ofSize: 16)).color(.lightGray).fits()
                        }
                        FSpacer()
                        FText($showSelected.asObservable().map{$0?.detail}).numberOfLines(0).font(.systemFont(ofSize: 14)).color(.lightGray)
                        FSpacer(4)
                        FText("Cast: \(series.showCast)").numberOfLines(0).font(.systemFont(ofSize: 14)).color(.lightGray)
                        FSpacer()
                        FHStack {
                            FVStack{
                                FImage(named: "add").width(50).height(50)
                                FSpacer()
                                FText("My list").font(.systemFont(ofSize: 14)).color(.lightGray).alignment(.center)
                            }
                            FSpacer(width: 40)
                            FVStack{
                                FImage(named: "share").width(50).height(50)
                                FSpacer()
                                FText("Share").font(.systemFont(ofSize: 14)).color(.lightGray).alignment(.center)
                            }
                        }
                        FSpacer(8)
                        FVStack().height(4).width(68).backgroundColor(.red)
                        FSpacer(4)
                        FHStack {
                            FText("EPISODES").font(.boldSystemFont(ofSize: 14)).color(.lightGray)
                            FSpacer(width: 20)
                            FText("MORE LIKE THIS").font(.systemFont(ofSize: 14)).color(.lightGray)
                        }
                        FSpacer()
                        FForEach(series.shows) { show in
                            FVStack {
                                FHStack {
                                    FImage(named: show.image).aspectRatio(16/10).height(100).margin(.right,12)
                                    FVStack {
                                        FText(show.title).font(.systemFont(ofSize: 14)).color(.lightGray)
                                        FSpacer(4)
                                        FText(show.length).font(.systemFont(ofSize: 10)).color(.lightGray)
                                    }.fits().alignSelf(.center)
                                    FImage(named: "download").width(25).height(25).alignSelf(.center)
                                }
                                FSpacer()
                            }
                            .onTapGesture{ _ in
                                showSelected = show
                            }
                            
                        }
                    }
                    .padding(12)
                    
                }.backgroundColor(.black)
                .debug(true)
            }
        }
        .title("Reywnderlich Tutorial")
        .viewWillAppear { 
            showSelected = series.shows[0]
        }
    }
}
```

<br>

The example implements the paging.

<br> 

<div>
<img src="https://github.com/chuthin/FlexBuilder/assets/4926746/a5d84e94-213b-472b-b165-afaf839bce60" width="300"/>
</div>

```swift
struct PagingViewController : ControllerBuilder {
    let  allItem:[Int] =  Array(0...4)
    @Variable var indicator = createSelect(5, index: 0)
    @Variable var page:Int = 0
    func view() -> any BuilderViewController {
        FViewController {
            FVStack {
                LazyGrid(allItem)
                    .register{
                        FCell<ItemCell,Int>()
                    }
                    .onSelect{
                        print($0.indexPath)
                    }
                    .onPageChange{ index in
                        indicator = createSelect(5, index: index)
                    }
                    .horizontalPage(bind: $page)
                    .showHorizontalIndicator(false)
                    .fits()
                    .pagingEnabled(true)
                    .layout(pagingLayout)
                FVStack{
                    DynamicForEach($indicator.asObservable()) { index, value in
                        FVStack()
                            .backgroundColor(value ? .white : .gray)
                            .height(10).width(10).cornerRadius(5)
                            .margin(.horizontal, 4)
                            .onTapGesture{_ in
                                page = index
                            }
                    }.direction(.row)
                }.alignItems(.center).margin(.bottom,24).position(.absolute).height(20).bottom(0).horizontally(12)
            }
        }
        .title("Paging View")
    }
}
```
<br>

The Example of using the Reader Monad to inject side effects in Github search .

<br> 

![ezgif-3-d647cf7a15](https://github.com/chuthin/FlexBuilder/assets/4926746/9f1b8de7-6ee1-4461-9bc0-490e701242ca)

```swift
struct GithubState  {
    var repos:[Repo] = []
    var isLoading = false
    var query: String = ""
    var route: AppRoute?
}

public enum GithubAction {
    case query(String)
    case repos([Repo])
    case goDetail(Repo)
    case more(Repo?)
}

struct GihubReducer : Reducer {
    static func reduce(state: GithubState, action: GithubAction) -> GithubState {
        switch action {
        case .query(let value):
            var result = GithubState()
            result.isLoading = true
            result.query = value
            return result
        case .repos(let items):
            var result = GithubState()
            result.repos = items
            return result
        case .goDetail(let repo):
            var result = state
            result.route = .reactive(.github(.detail(repo)))
            return result
        case .more(let repo):
            var result = state
            result.route = .reactive(.github(.open(repo)))
            return result
        }
    }
}

struct GihubEffector : Effector  {
    static func effect(state: Driver<GithubState>) -> Reader<Network, Driver<GithubAction>> {
        return .init{ world -> Driver<GithubAction> in
            let queryEffect = react(request: {$0}, effects: { resource -> Signal<GithubAction> in
                return world.getRepo(url: "https://api.github.com/search/repositories?q=\(resource)&page=\(1)&per_page=20")
                    .asSignal(onErrorSignalWith: .empty())
                    .map(GithubAction.repos)
            })(state.map{ $0.query}).asDriver(onErrorDriveWith: .empty())

            return Driver.merge(queryEffect)
        }
    }
}

struct GithubController : ReactViewController {
    let state: BehaviorRelay<GithubState>
    let handle: (GithubAction) -> Void
    @Variable var query: String = ""

    public init(state: BehaviorRelay<GithubState>, handle: @escaping (GithubAction) -> Void) {
        self.state = state
        self.handle = handle
    }

    func view() -> any BuilderViewController {
        FViewController {
            FVStack {
                FHStack {
                    FVStack{
                        FTextField($query).margin(.horizontal, 8).height(50)
                    }
                    .boder(.gray, 1).fits()
                    FButton("Search")
                        .backgroundColor(.gray)
                        .onTap{ _ in
                            handle(.query(query))
                        }
                }.padding(12)
                FSpacer()
                FList()
                    .itemsSource(state.map{$0.repos}.asObservable())
                    .register{
                        FCell<RepoCell,Repo>()
                            .dataContext{ cell, indexPath, repo, numberOfItems in
                                cell?.repo = repo
                                cell?.dividerHidden = indexPath.item == numberOfItems - 1
                            }
                            .action{ action in
                                handle(action)
                            }
                    }
                    .showVerticalIndicator(false)
                    .onSelect{ context in
                        if let repo = context.data as? Repo {
                            handle(.goDetail(repo))
                        }
                    }
                    .fits()
                FVStack {
                    FHStack {
                        UIActivityIndicatorView().then {
                            $0.startAnimating()
                            $0.color = .black
                        }.width(50).height(50)
                        FText("Loading...").margin(.right, 8)
                    }
                    .alignSelf(.center)
                    .backgroundColor(.lightGray)
                }
                .hidden(bind: state.map{ !$0.isLoading }.distinctUntilChanged())
                .justifyContent(.center)
                .position(.absolute)
                .all(0)
            }
        }
        .title("Github search")
        .navigate(state.map{ $0.route}.filter{ $0 != nil}.map{ $0!})
    }
}

```


