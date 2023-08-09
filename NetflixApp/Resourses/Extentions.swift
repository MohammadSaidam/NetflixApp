//
//  Extentions.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 02/08/2023.
//

import Foundation

extension String {
    func capitalizedFirstLetters()->String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
