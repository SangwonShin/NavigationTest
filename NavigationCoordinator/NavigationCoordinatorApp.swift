//
//  NavigationCoordinatorApp.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/06.
//

import SwiftUI

@main
struct NavigationCoordinatorApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(NavigationHelper())
    }
  }
}

enum ViewID: String {
  case a
  case b
  case c
  case d
  case e
  
  var id: String {
    return self.rawValue
  }
  
  var active: Bool {
    return false
  }
}
