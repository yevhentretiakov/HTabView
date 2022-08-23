//
//  TabListtViewController.swift
//  HTabView
//
//  Created by user on 16.08.2022.
//

import UIKit

final class TabListViewController: UIViewController {
    // MARK: - Properties
    
    private var tabView: HTabView = {
        let tabView = HTabView(tabs: ["longtab", "home", "family", "home", "family", "home", "family", "work", "home", "home", "family", "home", "family", "work", "home"],
                               indicatorActiveColor: .green,
                               indicatorInactiveColor: .label)
        return tabView
    }()
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutHTabView()
    }
    
    // MARK: - Layout Methods
    
    private func layoutHTabView() {
        view.addSubview(tabView)
        
        tabView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
