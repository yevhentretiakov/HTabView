//
//  HTabViewCell.swift
//  HTabView
//
//  Created by Yevhen Tretiakov on 16.08.2022.
//

import UIKit

final class HTabViewCell: UICollectionViewCell {
    // MARK: - Properties
    private var indicatorActiveColor: UIColor = .blue
    private var indicatorInactiveColor: UIColor = .label
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            setColorStyle()
        }
    }
    
    // MARK: - Life Cycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutTextLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with tabTitle: String, indicatorActiveColor: UIColor, indicatorInactiveColor: UIColor) {
        textLabel.text = tabTitle
        self.indicatorActiveColor = indicatorActiveColor
        self.indicatorInactiveColor = indicatorInactiveColor
        setColorStyle()
    }
    
    private func setColorStyle() {
        UIView.animate(withDuration: 0.2) {
            self.textLabel.textColor = self.isSelected ? self.indicatorActiveColor : self.indicatorInactiveColor
        }
    }
    
    // MARK: - Layout Methods
    private func layoutTextLabel() {
        addSubview(textLabel)
        textLabel.center(relativeTo: self)
    }
}
