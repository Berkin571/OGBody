//
//  String.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 13.05.25.
//

import Foundation

extension String {
  /// Entfernt alle Sternchen (*) aus dem String
  func removingStars() -> String {
    self.replacingOccurrences(of: "*", with: "")
  }
}
