//
//  HTabView.swift
//  HTabView
//
//  Created by Yevhen Tretiakov on 16.08.2022.
//

import UIKit

final class HTabView: UIView {
    // MARK: - Properties
    private var tabs: [String]
    private var indicatorActiveColor: UIColor
    private var indicatorInactiveColor: UIColor
    private let lineSpacing: CGFloat = 20
    private let contentInset: CGFloat = 15
    private let indicatorHeight: CGFloat = 5
    private let maxTabsCountForEqualWidth = 3
    private var selectedTabIndex = 0
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = lineSpacing
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewFlowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: contentInset,
                                                   bottom: 0,
                                                   right: contentInset)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var indicatorChevronView: UIView = {
        let view = UIView(frame: CGRect(x: .zero, y: .zero, width: .zero, height: indicatorHeight))
        view.backgroundColor = indicatorActiveColor
        view.makeRounded()
        return view
    }()
    
    // MARK: - Life Cycle Methods
    
    init(tabs: [String], indicatorActiveColor: UIColor, indicatorInactiveColor: UIColor) {
        self.tabs = tabs
        self.indicatorActiveColor = indicatorActiveColor
        self.indicatorInactiveColor = indicatorInactiveColor
        super.init(frame: .zero)
        setupCollectionView()
        addIndicatorChevronView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectTab(at: selectedTabIndex)
    }
    
    // MARK: - Methods
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HTabViewCell.self, forCellWithReuseIdentifier: String(describing: HTabViewCell.self))
        layoutCollectionView()
    }
    
    private func selectTab(at index: Int) {
        if tabs.indices.contains(index) {
            selectedTabIndex = index
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.selectItem(at: indexPath,
                                      animated: false,
                                      scrollPosition:.top)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            updateSelectedIndicator(at: index)
        }
    }
    
    private func updateSelectedIndicator(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        indicatorChevronView.frame.origin.y = self.frame.height - indicatorHeight
        UIView.animate(withDuration: 0.2) {
            if let cellAttributes = self.collectionView.layoutAttributesForItem(at: indexPath) {
                self.indicatorChevronView.frame.origin.x = cellAttributes.frame.origin.x
                self.indicatorChevronView.frame.size.width = cellAttributes.size.width
            }
        }
    }
    
    private func sizeForTab(at index: Int) -> CGSize? {
        if tabs.indices.contains(index) {
            if tabs.count <= maxTabsCountForEqualWidth {
                let contentWidth = self.bounds.width - contentInset * 2 - CGFloat((tabs.count - 1)) * lineSpacing
                return CGSize(width: contentWidth / CGFloat(tabs.count),
                              height: self.bounds.height)
            } else {
                return CGSize(width: tabs[index].textWidth(),
                              height: self.bounds.height)
            }
        } else {
            return nil
        }
    }
    
    // MARK: - Layout Methods
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addIndicatorChevronView() {
        collectionView.addSubview(indicatorChevronView)
    }
}

// MARK: - UICollectionViewDataSource
extension HTabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HTabViewCell.self),
                                                      for: indexPath) as! HTabViewCell
        
        let tabTitle = tabs[indexPath.row]
        cell.configure(with: tabTitle, indicatorActiveColor: indicatorActiveColor, indicatorInactiveColor: indicatorInactiveColor)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HTabView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectTab(at: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HTabView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForTab(at: indexPath.row) ?? .zero
    }
}
