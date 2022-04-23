//
//  CalendarView.swift
//  Demo
//
//  Created by SJZ on 2022/4/20.
//

import UIKit
import SnapKit

class CalendarView: UIView, UICollectionViewDelegate {
    
    var configure: CalendarConfigure = CalendarConfigure()
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>?
    
    private var monthModelArr: [[CalendarModel]] = []
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        // 隐藏滚动条
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.isPagingEnabled = true

        // 注册Cell
        collectionView.register(CalendarCell.classForCoder(), forCellWithReuseIdentifier: "CalendarCell")
        
        return collectionView
    }()
    
    // 初始化方法
    init(configure: CalendarConfigure) {
        self.configure = configure
        super.init(frame: .zero)
        
        monthModelArr = configure.monthModelArr
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 在这里设置，只是为了获取到视图大小的高度
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        
        // 滚动到当前月
        if collectionView.numberOfSections > configure.manager.currentMonthIndex {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: configure.manager.currentMonthIndex), at: .top, animated: false)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let groupHeight = self.frame.size.height / 6
        
        // 设置item大小
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 设置groupSize大小
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 7)
        
        // 设置section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        let configure = UICollectionViewCompositionalLayoutConfiguration()
        configure.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionNumber, env in
            return section
        }, configuration: configure)
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else {
                return CalendarCell()
            }
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var indexflag = 0
        for (index, modelArr) in monthModelArr.enumerated() {
            snapshot.appendSections([index])
            snapshot.appendItems(Array(1+indexflag...modelArr.count+indexflag))
            indexflag += modelArr.count
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    // 数据量太大，获取农历比较耗时，所以，将这一步放到即将展示的时候来做
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.section < self.monthModelArr.count,
              indexPath.item < self.monthModelArr[indexPath.section].count else {
            return
        }
        
        // 获取对应天数
        let modelArr = self.monthModelArr[indexPath.section]
        var model = modelArr[indexPath.item]
        self.configure.manager.configureModule(dateStr: "\(model.year)-\(model.month)-\(model.day)", model: &model)
        
        if let cell =  cell as? CalendarCell {
            cell.configureCell(model: model, configure: self.configure)
        }
    }
}

