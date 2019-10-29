//
//  Extensions.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/26/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

extension String {
	var optionalText: String? {
		let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
		return (trimmedText).isEmpty ? nil : trimmedText
	}
}

extension UITableView {
	func selectRow(at indexPath: IndexPath?) {
		let indexPath = indexPath ?? IndexPath(row: 0, section: 0)
		guard self.cellForRow(at: indexPath) != nil else { return }
		
		self.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
		self.delegate?.tableView?(self, didSelectRowAt: indexPath)
	}
}

extension NSString {
	@objc var firstChar: String? {
		return self.substring(to: 1)
	}
}
