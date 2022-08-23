//
//  HTabView.swift
//  HTabView
//
//  Created by user on 16.08.2022.
//

import UIKit

final class HTabView: UIView {
    // MARK: - Properties
    
    private var tabs: [String]!
    private var indicatorActiveColor: UIColor!
    private var indicatorInactiveColor: UIColor!
    private let lineSpacing: CGFloat = 20
    private let contentInset: CGFloat = 15
    private let indicatorHeight: CGFloat = 5
    private let maxTabsCountForEqualWidth = 3
    
    private var chevronLeadingConstraint: NSLayoutConstraint!
    private var chevronWidthConstraint: NSLayoutConstraint!
    
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
    
    private lazy var indicatorLineScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0,
                                               left: contentInset,
                                               bottom: 0,
                                               right: contentInset)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var indicatorChevronView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: .zero, height: indicatorHeight))
        view.backgroundColor = indicatorActiveColor
        view.makeRounded()
        return view
    }()
    
    // MARK: - Life Cycle Methods
    
    init(tabs: [String], indicatorActiveColor: UIColor, indicatorInactiveColor: UIColor) {
        super.init(frame: .zero)
        self.tabs = tabs
        self.indicatorActiveColor = indicatorActiveColor
        self.indicatorInactiveColor = indicatorInactiveColor
        setupCollectionView()
        layoutIndicatorLineView()
        selectTab(at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            let indexPath = IndexPath(item: index, section: 0)
            // Change tab color
            collectionView.selectItem(at: indexPath,
                                      animated: false,
                                      scrollPosition:.top)
            // Scroll to item
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            // Change chevron width and move to position
            UIView.animate(withDuration: 0.2) {
                if let cell = self.collectionView.cellForItem(at: indexPath) {
                    self.chevronLeadingConstraint.constant = cell.frame.origin.x
                }
                if let width = self.sizeForTab(at: index)?.width {
                    self.chevronWidthConstraint.constant = width
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Layout Methods
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func layoutIndicatorLineView() {
        addSubview(indicatorLineScrollView)
        
        indicatorLineScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorLineScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            indicatorLineScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            indicatorLineScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorLineScrollView.heightAnchor.constraint(equalToConstant: indicatorHeight)
        ])
        
        layoutIndicatorChevron()
    }
    
    private func layoutIndicatorChevron() {
        indicatorLineScrollView.addSubview(indicatorChevronView)
        
        indicatorChevronView.translatesAutoresizingMaskIntoConstraints = false
        chevronLeadingConstraint = indicatorChevronView.leadingAnchor.constraint(equalTo: indicatorLineScrollView.leadingAnchor)
        chevronLeadingConstraint.isActive = true
        chevronWidthConstraint = indicatorChevronView.widthAnchor.constraint(equalToConstant: 0)
        chevronWidthConstraint.isActive = true
        indicatorChevronView.heightAnchor.constraint(equalToConstant: indicatorHeight).isActive = true
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
}

// MARK: - UIScrollViewDelegate

extension HTabView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            indicatorLineScrollView.contentOffset.x = scrollView.contentOffset.x
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HTabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HTabViewCell.self), for: indexPath) as! HTabViewCell
        
        let tabTitle = tabs[indexPath.row]
        cell.configure(with: tabTitle, and: indicatorActiveColor, and: indicatorInactiveColor)
        
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
