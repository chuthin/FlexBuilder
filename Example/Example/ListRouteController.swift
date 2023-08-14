//
//  ListRouteController.swift
//  BuilderUI
//
//  Created by Chu Thin on 18/07/2023.
//

import Foundation
import FlexBuilder
struct RouteItem {
    var route:AppRoute
    var title:String
}

struct ListRouteController: ControllerBuilder {
    var items:[RouteItem]
    init(_ items:[RouteItem]) {
        self.items = items
    }

    func view() -> any ViewControllerBuilder {
        FViewController {
            FVStack {
                FForEach(items){  value in
                    FVStack {
                        FButton {
                            FText(value.title).color(.black).margin(.horizontal, 12)
                        }
                        .height(48)
                        .onTap{ context in
                            context.viewController?.navigate(value.route)
                        }
                        FDivider()
                    }

                }
            }
        }
        .title("FlexBuilder")
        .barStyle(.black)
    }
}
