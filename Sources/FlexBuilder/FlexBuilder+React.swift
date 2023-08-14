
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

public struct Reader<W, A> {
    private let g: (W) -> A

    public init(_ g: @escaping (W) -> A) {
        self.g = g
    }

    public static func pure(_ a: A) -> Reader<W, A> {
        return .init { e in a }
    }

    public func apply(_ world: W) -> A {
        return g(world)
    }

    public func map<B>(_ f: @escaping (A) -> B) -> Reader<W, B> {
        return Reader<W, B>{ e in f(self.g(e)) }
    }

    public func flatMap<B>(_ f: @escaping (A) -> Reader<W, B>) -> Reader<W, B> {
        return Reader<W, B>{ e in f(self.g(e)).g(e) }
    }
}

precedencegroup FlatMapPrecedence {
    associativity: left
}

infix operator >->: FlatMapPrecedence


func >-> <W, A, B>(a: Reader<W, A>, f: @escaping (A) -> Reader<W, B>) -> Reader<W, B> {
    return a.flatMap(f)
}

typealias Effect<W,S,A> = (Driver<S>) -> Reader<W,Driver<A>>

class RenderObject<S,E> :NSObject {
    let initState: S
    var environment: E?
    public var disposeBag: DisposeBag = DisposeBag()
    init(state:S, environment: E?) {

        self.initState = state
        self.environment = environment
    }

    func expo<A,V:FView>(scheduler:ImmediateSchedulerType,  viewBuilder: @escaping (BehaviorRelay<S>, @escaping (A) -> Void) -> V, reducer:@escaping (S,A) -> S, effect: Effect<E,S,A>?) -> V {
        let fakeActions  = BehaviorRelay<A?>(value: nil);
        let state = BehaviorRelay<S>(value: initState)
        if let environment = self.environment {
            effect?(state.asDriver(onErrorJustReturn: initState))
                .apply(environment)
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

        return viewBuilder(state) { action in
            fakeActions.accept(action);
        }
    }
}

public struct EffectView<W,V:ReactViewController,R:Reducer,E:Effector> : ControllerBuilder where R.State == V.State , R.Action == V.Action, E.State == V.State, E.Action == V.Action, E.World == W {
    var render: RenderObject<V.State,W>
    let viewBuilder: (BehaviorRelay<V.State>, @escaping (V.Action) -> Void) -> V
    public init(environment:W?, state: V.State) {
        self.render = RenderObject(state: state, environment: environment)
        self.viewBuilder = V.init
    }

    public func view() -> any ViewControllerBuilder {
        let vc =  render.expo(scheduler: MainScheduler.asyncInstance, viewBuilder: viewBuilder , reducer: R.reduce, effect: E.effect).view()
        if let controller = vc.viewController as? BuilderHostViewController {
            controller.disposeBag = self.render.disposeBag
        }
        return vc

    }
}

public struct NoEffectView<V:ReactViewController,R:Reducer> : ControllerBuilder where R.State == V.State , R.Action == V.Action{
    var render: RenderObject<V.State,Any>
    var viewBuilder: (BehaviorRelay<V.State>, @escaping (V.Action) -> Void) -> V
    public init(state: V.State) {
        self.render = RenderObject<V.State,Any>(state: state, environment: nil)
        self.viewBuilder = V.init
    }

    public func view() -> any ViewControllerBuilder {
        let vc =  render.expo(scheduler: MainScheduler.asyncInstance, viewBuilder: viewBuilder , reducer: R.reduce, effect: nil).view()
        if let controller = vc.viewController as? BuilderHostViewController {
            controller.disposeBag = self.render.disposeBag
        }
        return vc
    }
}

public protocol Reducer {
    associatedtype State
    associatedtype Action
    static func reduce(state: State, action: Action) -> State
}

public protocol Effector {
    associatedtype State
    associatedtype Action
    associatedtype World
    static func effect(state: Driver<State>) -> Reader<World,Driver<Action>>
}

public struct NoEffect<State,Action> : Effector {
    public static func effect(state: Driver<State>) -> Reader<Any,Driver<Action>> {
        Reader<Any,Driver<Action>>.pure(.empty())
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


