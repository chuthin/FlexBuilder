//
//  FlexBuilder+Group.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import Foundation

struct FGroup: ViewConvertable {

    private var views: [FView]

    public init(@ViewResultBuilder  _ views: () -> ViewConvertable) {
        self.views = views().asViews()
    }

    func asViews() -> [FView] {
        views
    }

}
