//
//  HTabViewCell.swift
//  HTabView
//
//  Created by user on 16.08.2022.
//

import UIKit

class HTabViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let reuseID = "HTabViewCell"
    private var indicatorColor: UIColor = .blue
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var bottomBorder: UIView = {
        let borderHeight: CGFloat = 5
        
        let border = UIView()
        border.backgroundColor = .clear
        border.layer.cornerRadius = borderHeight / 2

        border.translatesAutoresizingMaskIntoConstraints = false
        border.heightAnchor.constraint(equalToConstant: borderHeight).isActive = true
        
        return border
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.2) {
                    self.textLabel.textColor = self.indicatorColor
                    self.bottomBorder.backgroundColor = self.indicatorColor
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.textLabel.textColor = .label
                    self.bottomBorder.backgroundColor = .clear
                }
           }
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        layoutLabel()
        layoutBottomBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func set(label: String, indicatorColor: UIColor) {
        textLabel.text = label
        self.indicatorColor = indicatorColor
    }
    
    // MARK: - Layout Methods
    
    private func layoutLabel() {
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func layoutBottomBorder() {
        addSubview(bottomBorder)
        
        NSLayoutConstraint.activate([
            bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
