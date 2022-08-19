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
        var tabs = ["All", "Friends", "Family", "Work", "Friends", "Family", "Work", "Friends", "Family", "Work", "Friends", "Family", "Work", "Friends", "Family", "Work", "Friends", "Family", "Work", "Friends", "Family", "Work"]
        let tabView = HTabView(tabs: tabs, indicatorColor: .green)

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
