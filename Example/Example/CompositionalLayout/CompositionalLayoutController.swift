import Foundation
import FlexBuilder
public struct NewsFeedItem: Identifier {
    let title: String
    let date: String
    let body: String
}

extension NewsFeedItem : Hashable {}

enum Section : Hashable, Identifier {
    case list
    case grid
}

extension Section {
    static func fromIndex(_ index: Int) -> Section {
        if index == 0 {
            return .grid
        }
        return .list
    }
}

enum Item: Hashable {
    case news(NewsFeedItem)
    case video(Int)
}

extension Item : Identifier {
    var identifier: String {
        switch self {
        case .news:
            return NewsFeedItem.identifier
        case .video:
            return Int.identifier
        }
    }
    
    func asType<T>() -> T? {
        switch self {
        case .news(let value):
            return value as? T
        case .video(let value):
            return value as? T
        }
    }
}

extension Item {
    func getNews() -> NewsFeedItem? {
        if case .news(let value) = self {
            return value
        }
        return nil
    }
    
    func getVideo() -> Int? {
        if case .video(let value) = self {
            return value
        }
        return nil
    }
}

func getNewsFeed() -> [NewsFeedItem] {
    [ NewsFeedItem(title: "Conference 2019 Registration Now Open",
                                          date: "20/12/2019", body: """
                      Register by Wednesday, March 20, 2019 at 5:00PM.
                      """),
                             NewsFeedItem(title: "Apply for a Conference19 Scholarship",
                                          date: "12/08/2019", body: """
                      Conference Scholarships reward talented studens and STEM orgination members with the opportunity
                      to attend this year's conference. Apply by Sunday, March 24, 2019 at 5:00PM PDT
                      """),
                             NewsFeedItem(title: "Conference18 Video Subtitles Now in More Languages",
                                          date: "20/07/2019", body: """
                      All of this year's session videos are now available with Japanese and Simplified Chinese subtitles.
                      Watch in the Videos tab or on the Apple Developer website.
                      """),
                             NewsFeedItem(title: "Lunchtime Inspiration",
                                          date: "31/06/2019", body: """
                      All of this year's session videos are now available with Japanese and Simplified Chinease subtitles.
                      Watch in the Videos tab or on the Apple Developer website.
                      """),
                             NewsFeedItem(title: "Close Your Rings Challenge",
                                          date: "08/06/2019", body: """
                      Congratulations to all Close Your Rings Challenge participants for staying active
                      throughout the week! Everyone who participated in the challenge can pick up a
                      special reward pin outside on the Plaza until 5:00 p.m.
                      """),
    ]
}


struct CompositionalLayoutController : ControllerBuilder {

    @Variable var data = [
        DataSection(items:  Array(1...5).map{ Item.video($0)}, section: Section.grid),
        DataSection(items:  getNewsFeed().map{Item.news($0)}, section: Section.list)
    ]
    
    func view() -> any BuilderViewController {
        FViewController {
            FVStack(space: 6) {
                LazyGrid($data.asObservable())
                    .register{
                        FCell<ItemCell,Int>()
                            .dataContext{ cell, indexPath , newsItem, numberOfItems in
                                cell?.data = newsItem
                            }
                        FCell<ConferenceNewsFeedCell,NewsFeedItem>()
                            .dataContext{ cell, indexPath , newsItem, numberOfItems in
                                cell?.titleLabel.text(newsItem.title)
                                cell?.bodyLabel.text(newsItem.body)
                                cell?.dateLabel.text(newsItem.date)
                                cell?.showsSeparator = indexPath.item != numberOfItems - 1
                            }
                        FCell<HeaderCell,Section>(SupplementaryKind.header.rawValue)
                            .dataContext{ cell, _, section,_ in
                                switch section {
                                case .list:
                                    cell?.title.text("Today hot news")
                                    cell?.expandButton.display(false)
                                case .grid:
                                    cell?.title.text("Videos")
                                }
                            }
                            .action{ value in
                                print("Header Action")
                            }
                    }
                    .onSelect{
                        print($0.indexPath)
                    }
                    .fits()
                    .backgroundColor(.white)
                    .layout {
                        UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
                            switch Section.fromIndex(sectionNumber) {
                            case .list:
                                return listEstimateSection()
                            case .grid:
                                return gridSection()
                            }
                        }
                    }
            }
        }
        .title("CompositionalLayoutController")
        
    }
}


enum SupplementaryKind: String {
    case header = "section-header-element-kind"
    case footer = "section-footer-element-kind"
    case left = "section-left-element-kind"
    case right = "section-rigth-element-kind"
}

class HeaderCell : ActionSupplementaryView<HeaderAction> {
    var title : FText
    var expandButton: FButton
    
    override func initView() {
        title = FText()
        expandButton = FButton()
        super.initView()
    }
    
    override func body() -> FView {
        FHStack {
            title.numberOfLines(0).font(.preferredFont(forTextStyle: .title2)).color(.black).margin(.horizontal,12).fits()
            expandButton.title("show").margin(.right,12).backgroundColor(.green).height(36).alignSelf(.center).onTap{ _ in
                self.handle?(.more)
            }
        }
        .margin(.horizontal,12)
        .backgroundColor(.lightGray)
    }
}

enum HeaderAction {
    case more
}

private func gridSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                          heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(0.3))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitem: item, count: 3)
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .estimated(44)),
        elementKind: SupplementaryKind.header.rawValue,
        alignment: .top)
    sectionHeader.pinToVisibleBounds = true
    sectionHeader.zIndex = 2
    section.boundarySupplementaryItems = [sectionHeader]
    return section
}

private func listEstimateSection() -> NSCollectionLayoutSection {
    let columns = 1
    let estimatedHeight = CGFloat(48)
    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .estimated(estimatedHeight))
    let item = NSCollectionLayoutItem(layoutSize: layoutSize)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                   subitem: item,
                                                   count: columns)
    
    let section =  NSCollectionLayoutSection(group: group)
    
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .estimated(44)),
        elementKind: SupplementaryKind.header.rawValue,
        alignment: .top)
    sectionHeader.pinToVisibleBounds = true
    sectionHeader.zIndex = 2
    section.boundarySupplementaryItems = [sectionHeader]
    return section
}
