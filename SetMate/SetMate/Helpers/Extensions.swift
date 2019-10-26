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
