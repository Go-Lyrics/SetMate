//
//  CollapsableVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/23/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

import UIKit
@IBDesignable
class CollapsableVC: UIViewController {

	let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(isSwipeIsEnded))

	override func prepareForInterfaceBuilder() {
		customizeView()
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		customizeView()
	}

	func customizeView() {
		splitViewController?.preferredDisplayMode = .allVisible
		splitViewController?.presentsWithGesture = false

		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.down.right.and.arrow.up.left"), style: .plain, target: self, action: #selector(showPrimaryVC))

		edgePan.edges = .left
		view.addGestureRecognizer(edgePan)
	}

	@objc private func showPrimaryVC() {
		guard let splitVC = splitViewController else { return }
		if splitVC.displayMode == .primaryHidden {
			UIView.animate(withDuration: 0.3) {
				self.splitViewController?.preferredDisplayMode = .allVisible
				self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "arrow.down.right.and.arrow.up.left")
			}
		} else {
			UIView.animate(withDuration: 0.3) {
				self.splitViewController?.preferredDisplayMode = .primaryHidden
				self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
			}
		}
	}

	#warning("Fix later")
	@objc
	private func isSwipeIsEnded() {
		if edgePan.state == .ended {
			showPrimaryVC()
		}
	}
}
