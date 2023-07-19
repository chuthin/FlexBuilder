//
//  FlexBuilder+Grid.swift
//  FlexBuilder
//
//  Created by Chu Thin on 14/07/2023.
//

import UIKit
import RxSwift

open class BuilderCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, BaseItemsScrollView  {
    public var items:[Identifier] = []
    public var selectionHandler: SelectionHandler? = nil
    public var pagingHandler: ((Int) -> Void)?
    public var cells:[any AnyCell] = []
    
    init() {
        super.init( frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.delegate = self
        self.dataSource = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func register(_ cellClass: AnyClass?, kind: String?, reuseIdentifier identifier: String) {
        if let kind = kind {
            self.register(cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        } else {
            self.register(cellClass, forCellWithReuseIdentifier: identifier)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = items[safe: indexPath.item] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.identifier, for: indexPath)
            if let dataCell = cell  as? CellDataContext {
                if let cellDefine = cells.getCell(item.identifier) {
                    cellDefine.cellAction?(dataCell)
                    cellDefine.dataContext?(dataCell)?(indexPath,item,collectionView.numberOfItems(inSection: indexPath.section))
                }
                dataCell.setDataContext(indexPath:indexPath,data: item, numberOfItems: collectionView.numberOfItems(inSection: indexPath.section))
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CellDataContext , let selectionHandler = self.selectionHandler {
            let context = CellContext(data: cell.data, indexPath: indexPath)
            selectionHandler(context)
        }
    }
    
    public func setData(_ items:[Identifier]) {
        self.items = items
        self.reloadData()
    }
}

public struct FGrid: ModifiableView {
    public let modifiableView = BuilderCollectionView()

    public init() {
    }
    
    public init(_ items: [Identifier]) {
        modifiableView.setData(items)
    }
}

extension ModifiableView where Base : UICollectionView {
    public func layout( _ builder: () -> UICollectionViewLayout) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.setCollectionViewLayout(builder(), animated: false)
        }
    }
}

extension ModifiableView where Base : BuilderCollectionView {
    public func build() -> BuilderCollectionView {
        modifiableView
    }
}


open class BuilderSectionGridView<Section: Identifier,Item: Identifier>: UICollectionView, UICollectionViewDelegate,ItemsScrollView {
    public func register(_ cellClass: AnyClass?, kind: String?, reuseIdentifier identifier: String) {
        if let kind = kind {
            self.register(cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        } else {
            self.register(cellClass, forCellWithReuseIdentifier: identifier)
        }
    }
    
    public var selectionHandler: SelectionHandler? = nil
    public var pagingHandler: ((Int) -> Void)? = nil
    public var cells:[any AnyCell] = []
    public var items:[DataSection<Section,Item>] = []
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        super.init( frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.delegate = self
    }
    
   
    
    open func getSection(_ indexPath:IndexPath) -> DataSection<Section,Item>? {
        return items[safe: indexPath.section]
    }
    
    open func setData(_ data:DataSection<Section,Item>) {
        items = [data]
        
    }
    
    open func setData(_ data:[DataSection<Section,Item>]) {
        items = data
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CellDataContext , let selectionHandler = self.selectionHandler {
            let context = CellContext(data: cell.data, indexPath: indexPath)
            selectionHandler(context)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pagingHandler?(scrollView.currentPage)
    }
}

public struct DataSection<Section,Item> {
    public let items: [Item]
    public let section: Section
    public init(items: [Item], section: Section) {
        self.items = items
        self.section = section
    }
}

extension DataSection : Hashable where Section : Hashable, Item : Hashable {}
extension DataSection : Equatable where Section : Equatable, Item : Equatable {}

extension DataSection : Identifier {}
