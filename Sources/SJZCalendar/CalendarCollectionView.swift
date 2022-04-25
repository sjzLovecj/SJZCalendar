//
//  CalendarCollectionView.swift
//  Demo
//
//  Created by SJZ on 2022/4/20.
//

import UIKit
import SnapKit

protocol CalendarCollectionViewDelegate: NSObjectProtocol {
    func calendar(_ calendar: CalendarCollectionView, section: Int)
    func calendar(_ calendar: CalendarCollectionView, didSelectItem model: CalendarModel)
}

class CalendarCollectionView: UIView, UICollectionViewDelegate {
    
    weak var delegate: CalendarCollectionViewDelegate?
    
    var configure: CalendarConfigure = CalendarConfigure()
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>?
    
    private var weekTitle: WeekTitleView
    
    var showSection: Int = 0
    
    var scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .paging
    
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
        weekTitle = WeekTitleView(configure: configure)
        super.init(frame: .zero)
        
        monthModelArr = configure.monthModelArr
        
        addSubview(collectionView)
        addSubview(weekTitle)
        
        weekTitle.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(configure.weekTitleHeight)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(weekTitle.snp.bottom)
            make.bottom.left.right.equalToSuperview()
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
    
    // 下个月
    func nextMonth() {
        let showX = collectionView.contentOffset.x
        let showSection: Int = Int(showX / collectionView.frame.size.width)
        if showSection + 1 < monthModelArr.count {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: showSection + 1), at: .top, animated: true)
        }
    }
    
    // 上个月
    func previousMonth() {
        let showX = collectionView.contentOffset.x
        let showSection: Int = Int(showX / collectionView.frame.size.width)
        if showSection - 1 > 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: showSection - 1), at: .top, animated: true)
        }
    }
}

extension CalendarCollectionView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let showX = collectionView.contentOffset.x
        let showSection: Int = Int(showX / collectionView.frame.size.width)
        
        if self.showSection != showSection {
            self.showSection = showSection
            delegate?.calendar(self, section: showSection)
        }
    }
}

extension CalendarCollectionView {
    private func createLayout() -> UICollectionViewLayout {
        // 设置item大小
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 设置groupSize大小
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(configure.itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 7)
        
        // 设置section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollingBehavior
        
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
    
    // 数据量太大，获取农历比较耗时，所以，将这一步放到即将展示的时候来做
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.section < self.monthModelArr.count,
              indexPath.item < self.monthModelArr[indexPath.section].count else {
            return
        }
        
        // 获取对应天数
        let modelArr = self.monthModelArr[indexPath.section]
        var model = modelArr[indexPath.item]
        configure.manager.configureModule(dateStr: "\(model.year)-\(model.month)-\(model.day)", model: &model)
        
        if let cell =  cell as? CalendarCell {
            cell.configureCell(model: model, configure: configure)
        
            // 标记当前选中的indexPath,初始化时，默认为今天，这里只有当section 和 item都为0时，才赋值
            if model.isToday, configure.manager.selectIndexpath.section == 0, configure.manager.selectIndexpath.item == 0 {
                configure.manager.selectIndexpath = indexPath
            }
            
            cell.select = false
            if configure.manager.selectIndexpath == indexPath {
                cell.select = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCell,
              indexPath.section < self.monthModelArr.count,
              indexPath.item < self.monthModelArr[indexPath.section].count else {
            return
        }
        
        // 获取对应天数
        let modelArr = self.monthModelArr[indexPath.section]
        let model = modelArr[indexPath.item]
        
        if configure.onlyShowShowMonth, model.monthType != .showMonth {
            return
        }
        
        if let selectCell = collectionView.cellForItem(at: configure.manager.selectIndexpath) as? CalendarCell {
            selectCell.select = false
        }
        
        // 内置函数，当点击显示月中上个月或者下个月的日期时，需要自动滑动到需要显示的月
        func changeShowMonth(section: Int) {
            let changeArr = self.monthModelArr[section]
            for (index, changeModel) in changeArr.enumerated() {
                if changeModel.monthType != .showMonth {
                    continue
                }
                if changeModel.year == model.year,
                   changeModel.month == model.month,
                   changeModel.day == model.day {
                    configure.manager.selectIndexpath = IndexPath(row: index, section: section)
                    break
                }
            }
            collectionView.scrollToItem(at: IndexPath(row: 0, section: section), at: .top, animated: true)
        }
        
        if model.monthType == .showMonth {
            cell.select = true
            configure.manager.selectIndexpath = indexPath
        }else if model.monthType == .previousMonth, indexPath.section - 1 > 0 {
            changeShowMonth(section: indexPath.section - 1)
        }else if model.monthType == .nextMonth, indexPath.section + 1 < monthModelArr.count {
            changeShowMonth(section: indexPath.section + 1)
        }
    }
}

