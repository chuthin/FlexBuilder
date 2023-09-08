//
//  GithubController.swift
//  BuilderUI
//
//  Created by Chu Thin on 19/07/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback
import FlexBuilder

public struct GithubData  {
    var repos:[Repo]?
    var query:String = ""
    var page: Int = 1
    var isLoading : Bool = false
}

public enum GithubState  {
    case data(GithubData)
    case route(AppRoute,GithubData)
    case search(GithubData)
    case loadMore(GithubData)
}

public protocol GithubStateProtocol {
    var repos:[Repo]? {get}
    var isLoading:Bool {get}
    var route:AppRoute? {get}
    var query:String? {get}
    var data:GithubData {get}
    var isLoadMore:Bool {get}
    static func data(_ value:GithubData) -> Self
    static func route(_ route:AppRoute,_ value:GithubData) -> Self
    static func search(_ value:GithubData) -> Self
    static func loadMore(_ value:GithubData) -> Self
}

protocol GithubActionProtocol {
    static func query(_ value: String) -> Self
    static func repos(_ value: [Repo]) -> Self
    static func goDetail(_ value:Repo) -> Self
    static func more(_ value:Repo?) -> Self
    static func loadMore() -> Self
}


extension GithubState : GithubStateProtocol {
    public var isLoadMore: Bool {
        if case .loadMore = self {
            return true
        }
        return false
    }
    
    public var query: String? {
        if case .search(let data) = self {
            return query(text: data.query, page: data.page)
        } else if case .loadMore(let data) = self {
            return query(text: data.query, page: data.page)
        }
        return nil
    }

    func query(text:String, page: Int) -> String {
        return "https://api.github.com/search/repositories?q=\(data.query)&page=\(data.page)&per_page=20"
    }

    public var repos:[Repo]? {
        if case .data(let state) = self {
            return state.repos
        }
        return nil
    }

    public var route: AppRoute? {
        if case .route(let route,_) = self {
            return route
        }
        return nil
    }

    public var isLoading: Bool {
        return data.isLoading
    }

    public var data: GithubData {
        switch self {
        case .data(let data):
            return data
        case .route(_,let data):
            return data
        case .search(let data):
            return data
        case .loadMore(let data):
            return data
        }
    }
}


public enum GithubAction {
    case query(String)
    case repos([Repo])
    case goDetail(Repo)
    case more(Repo?)
    case loadMore
}

extension GithubAction : GithubActionProtocol {
    static func loadMore() -> GithubAction {
        return .loadMore
    }
}

public struct GihubReducer<State: GithubStateProtocol> : Reducer {
    public static func reduce(state: State, action: GithubAction) -> State {
        switch action {
        case .query(let value):
            var data = state.data
            data.query = value
            data.isLoading = true
            data.page = 1
            data.repos = []
            return .search(data)
        case .repos(let items):
            var data = state.data
            data.isLoading = false
            if data.repos?.isEmpty ?? true {
                data.repos = items
            } else {
                data.repos?.append(contentsOf: items)
            }
            return .data(data)
        case .goDetail(let repo):
            return .route(.reactive(.github(.detail(repo))), state.data)
        case .more(let repo):
            return .route(.reactive(.github(.open(repo))), state.data)
        case .loadMore:
            if state.isLoadMore || state.isLoading {
                return state
            }
            var data = state.data
            data.isLoading = true
            data.page += 1
            return .loadMore(data)
        }
    }
}

struct GihubEffector<State: GithubStateProtocol, Action: GithubActionProtocol> : Effector  {
    static func effect(eviroment: Network, query: String) -> Single<Action> {
        return eviroment.getRepo(url: query)
            .map(Action.repos(_:))
    }

    static func effect(eviroment:Network, state: Driver<State>) -> Driver<Action> {
        return react(request: {$0}, effects: { resouces -> Signal<Action> in
            return effect(eviroment: eviroment, query: resouces)
                .asSignal(onErrorSignalWith: .empty())
        })(state.map{ $0.query}.filter{ $0 != nil}).asDriver(onErrorDriveWith: .empty())
    }
}

class GithubController<State: GithubStateProtocol, Action: GithubActionProtocol> : BaseGithubController<State,Action> {}

class BaseGithubController<State: GithubStateProtocol, Action: GithubActionProtocol> : ReactViewController {
    let state: BehaviorRelay<State>
    let handle: (Action) -> Void
    @Variable var query: String = ""

    required public init(state: BehaviorRelay<State>, handle: @escaping (Action) -> Void) {
        self.state = state
        self.handle = handle
    }

    func dataView() -> FVStack {
        FVStack {
            FList()
                .itemsSource(state.map{$0.repos}.bindValue())
                .register{
                    FCell<RepoCell<Action>,Repo>()
                        .dataContext{ cell, indexPath, repo, numberOfItems in
                            cell?.repo = repo
                            cell?.dividerHidden = indexPath.item == numberOfItems - 1
                        }
                        .action{ action in
                            self.handle(action)
                        }
                }
                .showVerticalIndicator(false)
                .onSelect{[weak self]  context in
                    if let repo = context.data as? Repo {
                        self?.handle(.goDetail(repo))
                        
                    }
                }
                .loadMore { [weak self] in
                    self?.handle(.loadMore())
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
            .hidden(bind: state.map{!$0.isLoading}.bindDistinctValue())
            .justifyContent(.center)
            .position(.absolute)
            .all(0)
        }
    }
    
    func view() -> any ViewControllerBuilder {
        FViewController {
            FVStack {
                FHStack {
                    FVStack{
                        FTextField($query).margin(.horizontal, 8).height(50)
                    }
                    .boder(.gray, 1).fits()
                    FButton("Tìm kiếm")
                        .backgroundColor(.blue)
                        .onTap{[weak self] _ in
                            if let `self` = self {
                                self.handle(.query(self.query))
                            }
                        }
                }.padding(12)
                dataView().fits()
            }
        }
        .title("Github search hot reload")
        .rightBarButtonItems{
            FButton("Add")
                .color(.black)
                .margin(.horizontal, 12)
        }
        .navigate(state.map{ $0.route}.filter{ $0 != nil}.map{ $0!})
    }
}



struct GithubDetailView : ViewBuilder {
    var repo: Repo
    var body: FView {
        FVStack {
            FText(repo.name).font(.title1).color(.black)
            FSpacer()
            FText(repo.description).font(.body).color(.black).numberOfLines(0)
        }.padding(12)
    }
}

extension ModifiableView where Base: UIScrollView {
    func loadMore(_ action :@escaping () -> Void) -> Self {
        self.modifiableView.rx.contentOffset.asObservable()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak modifiableView] value in
                if let scroll = modifiableView, isNearBottomEdge(scrollView: scroll) {
                    action()
                }
            })
            .disposed(by: self.modifiableView.rxDisposeBag)
        return self
    }

    func isNearBottomEdge(scrollView: UIScrollView, edgeOffset: CGFloat = 0.0) -> Bool {
        return scrollView.contentOffset.y + scrollView.frame.size.height + edgeOffset > scrollView.contentSize.height
    }
}
