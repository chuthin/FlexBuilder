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
                                cell?.title.flexText(repo.name)
                                cell?.descriptonTitle.flexText(repo.description)
                                cell?.divier.hidden(indexPath.item == numberOfItems - 1)
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

struct GithubDetailView : ViewBuilder {
    var repo: Repo
    var body: View {
        FVStack {
            FText(repo.name).font(.title1).color(.black)
            FSpacer()
            FText(repo.description).font(.body).color(.black).numberOfLines(0)
        }.padding(12)
    }
}
