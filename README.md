# FlexBuilder: A Declarative UIKit Library
SwiftUI builder patterns for UIKit implemetation of [Builder](https://github.com/hmlongco/Builder) with [FlexLayout](https://github.com/layoutBox/FlexLayout) and [PinLayout](https://github.com/layoutBox/PinLayout)

This example is available in the [Examples App](https://github.com/chuthin/FlexBuilder/tree/main/Example).
<div>
<img src="https://github.com/chuthin/FlexBuilder/assets/4926746/62abf177-d461-4042-ac30-7b38ed575a6c" width="300"/>
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
            }
        }
        .title("Reywnderlich Tutorial")
        .viewWillAppear { 
            showSelected = series.shows[0]
        }
    }
}

```

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

