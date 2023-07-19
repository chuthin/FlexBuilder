//
//  FlexBuilder+List.swift
//  FlexBuilder
//
//  Created by Chu Thin on 13/07/2023.
//



import UIKit
import RxSwift
import RxCocoa
import FlexLayout

open class BuilderTableView: UITableView, UITableViewDelegate,UITableViewDataSource, BaseItemsScrollView  {
    public var selectionHandler: SelectionHandler? = nil
    public var pagingHandler: ((Int) -> Void)?
    public var items:[Identifier] = []
    public var cells:[any AnyCell] = []
    public init() {
        super.init(frame: .zero, style: .plain)
        self.estimatedRowHeight = 44
        self.separatorColor = .clear
        self.delegate = self
        self.dataSource = self
        self.rowHeight = UITableView.automaticDimension
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func register(_ cellClass: AnyClass?, kind: String?, reuseIdentifier identifier: String) {
        if let _ = kind {
            self.register(cellClass, forHeaderFooterViewReuseIdentifier: identifier)
        } else {
            self.register(cellClass, forCellReuseIdentifier: identifier)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = items[safe: indexPath.item] {
            let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
            if let dataCell = cell as? CellDataContext {
                if let cellDefine = cells.getCell(item.identifier) {
                    cellDefine.cellAction?(dataCell)
                    cellDefine.dataContext?(dataCell)?(indexPath,item,tableView.numberOfRows(inSection: indexPath.section))
                }
                dataCell.setDataContext(indexPath:indexPath,data: item, numberOfItems: tableView.numberOfRows(inSection: indexPath.section))
            }
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CellDataContext , let selectionHandler = self.selectionHandler {
            let context = CellContext(data: cell.data, indexPath: indexPath)
            selectionHandler(context)
        }
    }
    
    public func setData(_ items:[Identifier]) {
        self.items = items
        self.reloadData()
    }
}

public struct FList: ModifiableView {
    public let modifiableView = BuilderTableView()
    public init() {

    }
    
    public init(_ items: [Identifier]) {
        modifiableView.setData(items)
    }
}

extension ModifiableView where Base : BuilderTableView {
    public func build() -> BuilderTableView {
        modifiableView
    }
}
