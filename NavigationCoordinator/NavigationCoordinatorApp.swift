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
    let navigaitonViewModel = NavigationStack<ViewID>()
    WindowGroup {
      AView()
        .environmentObject(navigaitonViewModel)
    }
  }
}

enum ViewID: Equatable {
  case a
  case b
  case c
  case d
}
