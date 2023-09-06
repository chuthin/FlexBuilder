
//
//  ViewController.swift
//  BuilderFeedBack
//
//  Created by Chu Thin on 10/07/2023.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift

typealias Effect<W,S,A> = (W,Driver<S>) -> Driver<A>

class RenderObject<S,E> :NSObject {
    let initState: S
    var environment: E?
    public var disposeBag: DisposeBag = DisposeBag()
    var currentState: S
    init(state:S, environment: E?) {

        self.initState = state
        self.environment = environment
        self.currentState = state
    }

    func expo<A,V:FView>(scheduler:ImmediateSchedulerType,  viewBuilder: @escaping (BehaviorRelay<S>, @escaping (A) -> Void) -> V, reducer:@escaping (S,A) -> S, effect: Effect<E,S,A>?) -> V {
        let fakeActions  = BehaviorRelay<A?>(value: nil);
        let state = BehaviorRelay<S>(value: initState)
        if let environment = self.environment {
            effect?(environment,state.asDriver(onErrorJustReturn: initState))
                .asObservable()
                .bind(to: fakeActions)
                .disposed(by: disposeBag)
        }

        fakeActions.filter{$0 != nil}
            .map{$0!}
            .scan(initState, accumulator: reducer)
            .subscribe(on: scheduler)
            .startWith(initState)
            .bind(to: state)
            .disposed(by: disposeBag)

        state.asObservable()
            .subscribe(onNext:{[weak self] value in
                self?.currentState = value
            })
            .disposed(by: disposeBag)

        return viewBuilder(state) { action in
            fakeActions.accept(action);
        }
    }
}

public struct EffectView<W,V:ReactViewController,R:Reducer,E:Effector> : ReloadViewBuilder where R.State == V.State , R.Action == V.Action, E.State == V.State, E.Action == V.Action, E.Environment == W {

    var createInstance: EffectView<W, V, R, E> {
        return EffectView<W, V, R, E>(environment: environment, state: render.currentState)
    }

    var environment: W?
    var render: RenderObject<V.State,W>
    let viewBuilder: (BehaviorRelay<V.State>, @escaping (V.Action) -> Void) -> V
    public init(environment:W?, state: V.State) {
        self.render = RenderObject(state: state, environment: environment)
        self.viewBuilder = V.init
        self.environment = environment
    }

    public func view() -> any ViewControllerBuilder {
        let vc =  render.expo(scheduler: MainScheduler.asyncInstance, viewBuilder: viewBuilder , reducer: R.reduce, effect: E.effect).view()
        if let controller = vc.viewController as? BuilderHostViewController {
            controller.disposeBag = self.render.disposeBag
            controller.builder = self //EffectView(environment: environment, state: render.currentState)
        }
        return vc
    }
}

public struct NoEffectView<V:ReactViewController,R:Reducer> : ReloadViewBuilder where R.State == V.State , R.Action == V.Action{
    var createInstance: NoEffectView<V, R> {
        return NoEffectView<V, R>(state: render.currentState)
    }

    var environment: Any?
    var render: RenderObject<V.State,Any>
    var viewBuilder: (BehaviorRelay<V.State>, @escaping (V.Action) -> Void) -> V
    public init(state: V.State) {
        self.render = RenderObject<V.State,Any>(state: state, environment: self.environment)
        self.viewBuilder = V.init
    }

    public func view() -> any ViewControllerBuilder {
        let vc =  render.expo(scheduler: MainScheduler.asyncInstance, viewBuilder: viewBuilder , reducer: R.reduce, effect: nil).view()
        if let controller = vc.viewController as? BuilderHostViewController {
            controller.disposeBag = self.render.disposeBag
            #if DEBUG
            controller.builder = self
            #endif
        }
        return vc
    }
}

public struct ReloadView<V:ControllerBuilder> : ReloadViewBuilder {
    var createInstance: ReloadView {
        return ReloadView(self.viewBuilder())
    }

    var viewBuilder: () -> V

    public init(_ builder:@autoclosure @escaping () -> V ) {
        self.viewBuilder = builder
    }

    public func view() -> any ViewControllerBuilder {
        let builder = viewBuilder().view()
        #if DEBUG
        if let controller = builder.viewController as? BuilderHostViewController {
            controller.builder = self
        }
        #endif
        return builder
    }
}

protocol ReloadViewBuilder : ControllerBuilder {
    var createInstance:Self {get}
}


public protocol Reducer {
    associatedtype State
    associatedtype Action
    static func reduce(state: State, action: Action) -> State
}

public protocol Effector {
    associatedtype State
    associatedtype Action
    associatedtype Environment
    static func effect(eviroment:Environment, state: Driver<State>) -> Driver<Action>
}

public struct NoEffect<State,Action> : Effector {
    public static func effect(eviroment:Any, state: Driver<State>) -> Driver<Action> {
        .empty()
    }
}

public typealias Handle<Action> = (Action) -> Void
public protocol ReactViewController : ControllerBuilder {
    associatedtype State
    associatedtype Action
    var state: BehaviorRelay<State> { get}
    var handle: (Action) -> Void { get}
    init(state: BehaviorRelay<State>, handle: @escaping (Action) -> Void)
}


public extension SharedSequenceConvertibleType  {
    func bindValue<A>() -> SharedSequence<Self.SharingStrategy,A> where Element == Optional<A> {
        return self.filter{ $0 != nil}.map{ $0!}
    }
    
    func bindDistinctValue<A: Equatable>() -> SharedSequence<Self.SharingStrategy,A> where Element == Optional<A> {
        return self.filter{ $0 != nil}.map{ $0!}.distinctUntilChanged()
    }
}

public extension Observable {
    func bindValue<A>() -> Observable<A> where Element == Optional<A> {
        return self.filter{ $0 != nil}.map{ $0!}
    }
    
    func bindDistinctValue<A: Equatable>() -> Observable<A> where Element == Optional<A> {
        return self.filter{ $0 != nil}.map{ $0!}.distinctUntilChanged()
    }
}
