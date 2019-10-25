//
//  SetMateTabBarController.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/24/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class SetMateTabBarController: UITabBarController {

	enum tabBarMenu: Int {
		case home
		case list
		case settings
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		selectedIndex = 2
		guard let tabBarMenuItem = tabBarMenu(rawValue: 0) else { return }
		setTintColor(forMenuItem: tabBarMenuItem)
	}

	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

		guard
			let menuItemSelected = tabBar.items?.firstIndex(of: item),
			let tabBarMenuItem = tabBarMenu(rawValue: menuItemSelected)
			else { return }

		setTintColor(forMenuItem: tabBarMenuItem)
	}

	// MARK: Private

	private func setTintColor(forMenuItem tabBarMenuItem: tabBarMenu) {
		switch tabBarMenuItem {
		case .home:
			viewControllers?[tabBarMenuItem.rawValue].tabBarController?.tabBar.tintColor = .systemIndigo
		case .list:
			viewControllers?[tabBarMenuItem.rawValue].tabBarController?.tabBar.tintColor = .systemPink
		case .settings:
			viewControllers?[tabBarMenuItem.rawValue].tabBarController?.tabBar.tintColor = .systemTeal
		}
	}
}
