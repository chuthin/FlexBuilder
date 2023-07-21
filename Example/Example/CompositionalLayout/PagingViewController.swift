//
//  PagingViewController.swift
// FlexBuilder
//
//  Created by Chu Thin on 14/07/2023.
//

import Foundation
import UIKit
import FlexBuilder
import FlexLayout

struct PagingViewController : ControllerBuilder {
    let  allItem:[Int] =  Array(0...4)
    @Variable var indicator = createSelect(5, index: 0)
    @Variable var page:Int = 0
    func view() -> any BuilderViewController {
        FViewController {
            FVStack {
                LazyGrid(allItem)
                    .register{
                        FCell<ItemCell,Int>()
                    }
                    .onSelect{
                        print($0.indexPath)
                    }
                    .onPageChange{ index in
                        indicator = createSelect(5, index: index)
                    }
                    .horizontalPage(bind: $page)
                    .showHorizontalIndicator(false)
                    .fits()
                    .pagingEnabled(true)
                    .layout(pagingLayout)
                FVStack{
                    DynamicForEach($indicator.asObservable()) { index, value in
                        FVStack()
                            .backgroundColor(value ? .white : .gray)
                            .height(10).width(10).cornerRadius(5)
                            .margin(.horizontal, 4)
                            .onTapGesture{_ in
                                page = index
                            }
                    }.direction(.row)
                }.alignItems(.center).margin(.bottom,24).position(.absolute).height(20).bottom(0).horizontally(12)
            }
        }
    }
}

func createSelect(_ count:Int, index:Int) -> [Bool] {
    return Array(0...count - 1).map{ item in
        return item == index
    }
}

private func pagingLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(1.0))
    
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .horizontal
    
    let layout = UICollectionViewCompositionalLayout(section: section)
    layout.configuration = config
    
    return layout
}
