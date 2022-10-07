//
//  File.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/07.
//

import Foundation
import SwiftUI
import UIKit

final class NavigationHelper: ObservableObject {
  @Published var goToA: Bool = false {
    didSet {
      print("A State is Changed", self.goToA)
    }
  }
  @Published var goToB: Bool = false {
    didSet {
      print("B State is Changed", self.goToB)
    }
  }
  @Published var goToC: Bool = false {
    didSet {
      print("C State is Changed", self.goToC)
    }
  }
}
