//
//  MainTabBarController.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/25/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

	enum tabBarMenu: Int {
		case perform
		case manageSongs
		case manageSets
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let tabBarMenuItem = tabBarMenu(rawValue: 0) else { return }
		setTintColor(forMenuItem: tabBarMenuItem)
	}

	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		guard let menuItemSelected = tabBar.items?.firstIndex(of: item),
			let tabBarMenuItem = tabBarMenu(rawValue: menuItemSelected)
			else { return }

		setTintColor(forMenuItem: tabBarMenuItem)
	}

	// MARK: Private

	private func setTintColor(forMenuItem tabBarMenuItem: tabBarMenu) {
		switch tabBarMenuItem {
		case .perform:
			viewControllers?[tabBarMenuItem.rawValue].tabBarController?.tabBar.tintColor = .systemBlue
		case .manageSongs:
			viewControllers?[tabBarMenuItem.rawValue].tabBarController?.tabBar.tintColor = .systemPink
		case .manageSets:
			viewControllers?[tabBarMenuItem.rawValue].tabBarController?.tabBar.tintColor = .systemIndigo
		}
	}
}
