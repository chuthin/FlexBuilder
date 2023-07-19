//
//  CounterController.swift
//  BuilderUI
//
//  Created by Chu Thin on 19/07/2023.
//

import Foundation
import RxSwift
import RxCocoa
import FlexBuilder
typealias CounterState = Int
enum CounterAction {
    case increment
    case decrement
}

struct CounterReducer : Reducer {
    static func reduce(state: CounterState, action: CounterAction) -> CounterState {
        switch (action) {
        case .increment :
            return state + 1
        case .decrement :
            return state - 1
        }
    }
}

struct CounterController : ReactViewController {
    let state: BehaviorRelay<CounterState>
    let handle: (CounterAction) -> Void
    init(state: BehaviorRelay<CounterState>, handle: @escaping (CounterAction) -> Void) {
        self.state = state
        self.handle = handle
    }

    func view() -> any BuilderViewController {
        FViewController {
            FVStack {
                FHStack{
                    FButton("Increment")
                        .onTap{ _ in
                            handle(.increment)
                        }.backgroundColor(.blue).height(48)
                        .fits()
                    FSpacer(width: 8)
                    FText(state.map{"\($0)"}).width(50).alignment(.center)
                    FSpacer(width: 8)
                    FButton("Decrement")
                        .onTap{ _ in
                            handle(.decrement)
                        }.backgroundColor(.blue).height(48)
                        .fits()
                }.padding(12)
            }.justifyContent(.center)
        }
        .title("Counter")
    }
}
