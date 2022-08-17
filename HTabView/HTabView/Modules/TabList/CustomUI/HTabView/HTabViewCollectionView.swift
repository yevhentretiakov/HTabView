//
//  HTabView.swift
//  HTabView
//
//  Created by user on 16.08.2022.
//

import UIKit

class HTabView: UIView {
    // MARK: - Properties
    
    private var tabs: [String]!
    private var indicatorColor: UIColor!
    private var lineSpacing = 5
    private var contentInset: CGFloat = 15
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewFlowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: contentInset, bottom: 0, right: contentInset)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    // MARK: - Life Cycle Methods
    
    init(tabs: [String], indicatorColor: UIColor = .blue) {
        super.init(frame: .zero)
        self.tabs = tabs
        self.indicatorColor = indicatorColor
        setupCollectionView()
        layoutCollectionView()
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
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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
        cell.set(label: tab, indicatorColor: indicatorColor)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HTabView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if tabs.count <= 3 {
            let contentWidth = Int(self.bounds.width) - Int(contentInset * 2) - (tabs.count - 1) * lineSpacing
            return CGSize(width: CGFloat(contentWidth) / CGFloat(tabs.count),
                          height: self.bounds.height)
        } else {
            let tagText = tabs[indexPath.item]
            return CGSize(width: tagText.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width, height: self.bounds.height)
        }
    }
}
