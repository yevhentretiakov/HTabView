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
    private var indicatorColor: UIColor!
    private let lineSpacing: CGFloat = 20
    private let contentInset: CGFloat = 15
    private let indicatorHeight: CGFloat = 5
    
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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: contentInset, bottom: 0, right: contentInset)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var indicatorLineView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: contentInset, bottom: 0, right: contentInset)
        return scrollView
    }()
    
    private lazy var indicatorLineContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var indicatoChevronView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: .zero, height: indicatorHeight))
        view.backgroundColor = indicatorColor
        view.makeRounded()
        return view
    }()
    
    // MARK: - Life Cycle Methods
    
    init(tabs: [String], indicatorColor: UIColor = .blue) {
        super.init(frame: .zero)
        self.tabs = tabs
        self.indicatorColor = indicatorColor
        setupCollectionView()
        layoutCollectionView()
        layoutIndicatorLine()
        layoutIndicatoChevron()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HTabViewCell.self, forCellWithReuseIdentifier: HTabViewCell.reuseID)
        setSelectedCell(at: 0)
    }
    
    private func setSelectedCell(at index: Int) {
        if tabs.indices.contains(index) {
            collectionView.selectItem(at: IndexPath(item: index, section: 0),
                                      animated: false,
                                      scrollPosition:.top)
        }
    }
    
    // MARK: - Layout Methods
    
    private func layoutCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func layoutIndicatorLine() {
        indicatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(indicatorLineView)
        
        NSLayoutConstraint.activate([
            indicatorLineView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            indicatorLineView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            indicatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorLineView.heightAnchor.constraint(equalToConstant: indicatorHeight)
        ])
        
        indicatorLineContentView.translatesAutoresizingMaskIntoConstraints = false
        
        indicatorLineView.addSubview(indicatorLineContentView)
        NSLayoutConstraint.activate([
            indicatorLineContentView.leadingAnchor.constraint(equalTo: indicatorLineView.leadingAnchor),
            indicatorLineContentView.trailingAnchor.constraint(equalTo: indicatorLineView.trailingAnchor),

            indicatorLineContentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorLineContentView.heightAnchor.constraint(equalToConstant: indicatorHeight)
        ])
    }
    
    private func layoutIndicatoChevron() {
        indicatorLineView.addSubview(indicatoChevronView)
        
        let tagText = tabs[0]
        
        // TODO: - Create string extension to get text width
        let firstItemSize = tagText.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width

        indicatoChevronView.translatesAutoresizingMaskIntoConstraints = false
        
        chevronLeadingConstraint = indicatoChevronView.leadingAnchor.constraint(
            equalTo: indicatorLineContentView.leadingAnchor
        )
        chevronLeadingConstraint.isActive = true
        chevronWidthConstraint = indicatoChevronView.widthAnchor.constraint(equalToConstant: firstItemSize)
        chevronWidthConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            indicatoChevronView.topAnchor.constraint(equalTo: indicatorLineContentView.topAnchor),
            indicatoChevronView.bottomAnchor.constraint(equalTo: indicatorLineContentView.bottomAnchor)
        ])
    }
}

// MARK: - UIScrollViewDelegate

extension HTabView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let x = scrollView.contentOffset.x
            indicatorLineView.contentOffset.x = x
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HTabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HTabViewCell.reuseID, for: indexPath) as! HTabViewCell
    
        let tab = tabs[indexPath.row]
        cell.set(label: tab)
        cell.indicatorColor = indicatorColor
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HTabView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                self.chevronLeadingConstraint.constant = cell.frame.origin.x
                self.chevronWidthConstraint.constant = cell.bounds.width
                self.layoutIfNeeded()
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HTabView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if tabs.count <= 3 {
            let contentWidth = self.bounds.width - contentInset * 2 - CGFloat((tabs.count - 1)) * lineSpacing
            return CGSize(width: contentWidth / CGFloat(tabs.count),
                          height: self.bounds.height)
        } else {
            let tagText = tabs[indexPath.item]
            return CGSize(width: tagText.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width, height: self.bounds.height)
        }
    }
}
