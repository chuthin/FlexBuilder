//
//  AppRoute.swift
//  BuilderUI
//
//  Created by Chu Thin on 18/07/2023.
//

import UIKit
import RxSwift
import FlexBuilder
public enum RouteType {
    case push(UIViewController)
    case present(UIViewController)
    case open(String)
}

public protocol Routable {
    var route: RouteType { get }
}

extension UIViewController {
     func navigate(_ route: AppRoute) {
        switch route.route {
        case .push(let vc):
            self.navigationController?.pushViewController(vc, animated: true)
        case .present(let vc):
            self.present(vc, animated: true)
        case .open(let value):
            if let url = URL(string: value) {
                UIApplication.shared.open(url)
            }
        }
    }
}

extension BuilderViewController {
    func navigate(_ route:Observable<AppRoute>) -> Self {
        route.observe(on: MainScheduler.instance)
            .subscribe(onNext:{ [weak viewController] value in
                viewController?.navigate(value)
            })
            .disposed(by: self.viewController.rxDisposeBag)
        return self
    }
}

enum AppRoute {
    case layout(LayoutRoute)
    case reactive(ReactiveRoute)
}

extension AppRoute : Routable {
    var route: RouteType {
        switch self {
        case .layout(let value):
            return value.route
        case .reactive(let value):
            return value.route
        }
    }
}

enum LayoutRoute  {
    case all
    case list
    case raywenderlich
    case pagingView
    case alert
    case compositional
}

enum ReactiveRoute {
    case all
    case counter
    case github(GithubRoute)
}

enum GithubRoute {
    case list
    case detail(Repo)
    case open(Repo?)
}

extension LayoutRoute : Routable {
    var route: RouteType {
        switch self  {
        case .all:
            let vc = ListRouteController([
                RouteItem(route: .layout(.list), title: "List layout"),
                RouteItem(route: .layout(.pagingView), title: "Paging View"),
                RouteItem(route: .layout(.alert), title: "Alert"),
                RouteItem(route: .layout(.compositional), title: "Compositional Layout"),
                RouteItem(route: .layout(.raywenderlich), title: "RaywenderlichTutorial")]).viewController
            vc.title = "Layout"
            return .push(vc)
        case .list:
            return .push(ListController().viewController)
        case .raywenderlich:
            return .push(ReywnderlichTutorialController().viewController)
        case .alert:
            return .push(AlertViewController().viewController)
        case .pagingView:
            return .push(PagingViewController().viewController)
        case .compositional:
            return .push(CompositionalLayoutController().viewController)
        }
    }
}


extension ReactiveRoute {
    var route: RouteType {
        switch self {
        case .all:
            let vc = ListRouteController([
                RouteItem(route: .reactive(.counter), title: "Counter"),
                RouteItem(route: .reactive(.github(.list)), title: "Github search")]).viewController
            vc.title = "Reactive"
            return .push(vc)
        case .counter:
            return .present(NoEffectView<CounterController,CounterReducer>( state: 0).viewController)
        case .github(let value):
            return value.route
        }
    }
}

extension GithubRoute: Routable {
    var route: RouteType {
        switch self {
        case .list:
            return .push(EffectView<Network,GithubController,GihubReducer,GihubEffector>(environment: NetworkEnvironment(),state: GithubState()).viewController)
        case .detail(let repo):
            return .present(HostViewController(GithubDetailView(repo: repo).build()))
        case .open(let repo):
            return .open(repo?.html_url ?? "")
        }
    }
}
