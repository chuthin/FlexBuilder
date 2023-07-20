//
//  Builder+LazyGrid.swift
// FlexBuilder
//
//  Created by Chu Thin on 15/07/2023.
//

import Foundation
import UIKit
import RxSwift
import FlexBuilder
import DiffableDataSources


open class BuilderLazyGridView<Section:Hashable & Identifier,Item:Hashable & Identifier>: BuilderSectionGridView <Section, Item>{
    var lazyDataSource: UICollectionViewDiffableDataSource<Section, Item>?
    override init() {
        super.init()
        self.configureDataSource()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDataSource() {
        lazyDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier.identifier,for: indexPath)
            if let dataCell = cell as? CellDataContext {
                if let view = collectionView as? BuilderLazyGridView,  let cellDefine = view.cells.getCell(identifier.identifier) {
                    cellDefine.cellAction?(dataCell)
                    cellDefine.dataContext?(dataCell)?(indexPath,identifier,collectionView.numberOfItems(inSection: indexPath.section))
                }
                dataCell.setDataContext(indexPath: indexPath, data: identifier, numberOfItems: collectionView.numberOfItems(inSection: indexPath.section))
            }
            return cell
        }
        
        lazyDataSource?.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if let view = collectionView as? BuilderLazyGridView,let item = view.getSection(indexPath) {
                let headerFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: item.section.identifier,for: indexPath)
                if let dataCell = headerFooter as? CellDataContext {
                    if let cellDefine = view.cells.getCell(item.section.identifier) {
                        cellDefine.cellAction?(dataCell)
                        cellDefine.dataContext?(dataCell)?(indexPath, item.section,collectionView.numberOfItems(inSection: indexPath.section))
                    }
                    dataCell.setDataContext(indexPath: indexPath, data: item.section, numberOfItems: collectionView.numberOfItems(inSection: indexPath.section))
                }
                return headerFooter
            }
            return nil
        }
    }

    public override func setData(_ data:DataSection<Section,Item>) {
        items = [data]
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([data.section])
        snapshot.appendItems(data.items)
        lazyDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    public override func setData(_ data:[DataSection<Section,Item>]) {
        items = data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        for item in data {
            snapshot.appendSections([item.section])
            snapshot.appendItems(item.items)
        }
        lazyDataSource?.apply(snapshot, animatingDifferences: true)
    }
}

public struct AnyLazyGrid<Section:Hashable & Identifier,Item:Hashable & Identifier>: ModifiableView {
    public let modifiableView = BuilderLazyGridView<Section,Item>()
    
    public init() {
    }
    
    public init(section:Section,items: [Item]) {
        modifiableView.setData(DataSection(items: items, section: section))
    }
    
    public init(data:DataSection<Section,Item>) {
        modifiableView.setData(data)
    }
    
    public init(data:[DataSection<Section,Item>]) {
        modifiableView.setData(data)
    }
    
    public init(data:Observable<DataSection<Section,Item>>) {
        data
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext:{[weak modifiableView] value in
                modifiableView?.setData(value)
            }).disposed(by: modifiableView.rxDisposeBag)
    }
    public init(data:Observable<[DataSection<Section,Item>]>) {
        data
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext:{[weak modifiableView] value in
                modifiableView?.setData(value)
            }).disposed(by: modifiableView.rxDisposeBag)
    }
}

public func LazyGrid<Item:Hashable>(_ items:[Item]) -> AnyLazyGrid<Int,Item> {
    return AnyLazyGrid(data: DataSection(items: items, section: 0))
}

public func LazyGrid<Item:Hashable>(_ items:Observable<[Item]>) -> AnyLazyGrid<Int,Item> {
    return AnyLazyGrid(data: items.map{DataSection(items: $0, section: 0)  })
}

public func LazyGrid<Item:Hashable>(_ data:DataSection<Int,Item>) -> AnyLazyGrid<Int,Item> {
    return AnyLazyGrid(data: data)
}

public func LazyGrid<Section:Hashable,Item:Hashable>(_ data:[DataSection<Section,Item>]) -> AnyLazyGrid<Section,Item> {
    return AnyLazyGrid(data: data)
}

public func LazyGrid<Section:Hashable,Item:Hashable>(_ data:Observable<[DataSection<Section,Item>]>) -> AnyLazyGrid<Section,Item> {
    return AnyLazyGrid(data: data)
}

extension Int : Identifier {}

