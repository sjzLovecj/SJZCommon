//
//  SJZCollectionController.swift
//  SJZ
//
//  Created by S JZ on 2022/10/31.
//

import UIKit

open class SJZCollectionController<SectionType, ItemType>: SJZBaseController where SectionType: Hashable, ItemType: Hashable {

    // 快照
    public lazy var snapshot: NSDiffableDataSourceSnapshot<SectionType, ItemType> = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
    // 数据源
    public lazy var dataSource: UICollectionViewDiffableDataSource<SectionType, ItemType> = {
        let dataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>.init(collectionView: self.collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else { return UICollectionViewCell() }
            return self.configureCellProvider(collectionView, indexPath, itemIdentifier)
        }
        
        return dataSource
    }()
    // 创建基础cellRegist
    public var baseCellRegist: UICollectionView.CellRegistration<UICollectionViewCell, ItemType>!
    
    // collectionView
    public private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        registProvider()
    }
    
    private func registProvider() {
        baseCellRegist = registCell(CellType: UICollectionViewCell.self) { [weak self] cell, indexPath, itemIdentifier in
            guard let self = self else { return }
            self.configureCell(cell, indexPath, itemIdentifier)
        }
        
//        baseHeadRegist = UICollectionView.SupplementaryRegistration<UICollectionReusableView>(elementKind: "headRegist") { supplementaryView, elementKind, indexPath in
//
//        }
//
//        baseFootRegist = UICollectionView.SupplementaryRegistration<UICollectionReusableView>(elementKind: "footRegist") { supplementaryView, elementKind, indexPath in
//
//        }
//
//
//        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
//            guard let self = self else { return nil}
//
//            if kind == "headRegist" {
//                return self.collectionView.dequeueConfiguredReusableSupplementary(using: self.baseHeadRegist, for: index)
//            }else if kind == "footRegist" {
//                return self.collectionView.dequeueConfiguredReusableSupplementary(using: self.baseFootRegist, for: index)
//            }else  {
//
//            }
//
//            return nil
//        }
    }
    
    open override func buildSubView(contentView superView: UIView) {
        addSubView(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 配置collectionView 的布局
    open func configureLayout() -> UICollectionViewLayout {
        let configure = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { section, environment in
            return nil
        }, configuration: configure)
        return layout
    }
    
    // MARK: - dataSource 与 Cell
    // 封装注册Cell
    open func registCell<Cell>(CellType: Cell.Type, handler: @escaping UICollectionView.CellRegistration<Cell, ItemType>.Handler) -> UICollectionView.CellRegistration<Cell, ItemType> where Cell: UICollectionViewCell {
        let cell = UICollectionView.CellRegistration<Cell, ItemType>{ (cell, indexPath, identifier) in
            handler(cell, indexPath, identifier)
        }
        
        return cell
    }
    
    // 配置Cell
    open func configureCell(_ cell: UICollectionViewCell, _ indexPath: IndexPath, _ itemIdentifier: ItemType) {
        
    }
    
    // 封装DateSource
    open func configureCellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: ItemType) -> UICollectionViewCell? {
        return collectionView.dequeueConfiguredReusableCell(using: baseCellRegist, for: indexPath, item: itemIdentifier)
    }
}
