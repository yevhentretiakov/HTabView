//
//  HTabViewCell.swift
//  HTabView
//
//  Created by user on 16.08.2022.
//

import UIKit

final class HTabViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let reuseID = "HTabViewCell"
    
    var indicatorColor: UIColor = .blue {
        didSet {
            setColorStyle()
        }
    }
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        layoutLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func set(label: String) {
        textLabel.text = label
    }
    
    private func setColorStyle() {
        UIView.animate(withDuration: 0.2) {
            if self.isSelected {
                self.textLabel.textColor = self.indicatorColor
            } else {
                self.textLabel.textColor = .label
           }
        }
    }
    
    // MARK: - Layout Methods
    
    private func layoutLabel() {
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
