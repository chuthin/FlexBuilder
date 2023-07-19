//
//  ListController.swift
//  BuilderUI
//
//  Created by Chu Thin on 18/07/2023.
//

import Foundation
import FlexBuilder
struct ListController : ControllerBuilder {
    var repos:[Identifier] {
        var result:[Identifier] = []
        result.append("Programing language")
        result.append(contentsOf: Data.programing)
        result.append("Scripting language")
        result.append(contentsOf: Data.scripting)
        return result

    }
    
    func view() -> any BuilderViewController {
        return FViewController {
            FVStack {
                FList(repos)
                    .register{
                        FCell<TitleHeaderCell,String>()
                        FCell<TitleCell,Lang>()
                            .dataContext { cell, index, lang, count in
                                cell?.title.flexText(lang.name)
                                cell?.descriptonTitle.flexText(lang.description)
                                cell?.divier.display(index.item ==  Data.programing.count || index.item == count - 1 ? .none : .flex)
                            }
                    }
                    .showVerticalIndicator(false)
                    .onSelect{ value in
                        print(value.indexPath)
                    }.fits()

            }
        }
        .title("List layout")
    }
}


extension Lang : Identifier {}

public struct Lang : Codable {
    public let name:String?
    public let description: String?
}

extension  String : Identifier {}
