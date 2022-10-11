//
//  NavigationLazyView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/11.
//

import Foundation
import SwiftUI

struct NavigationLazyView<Content: View>: View {
  let build: () -> Content
  init(_ build: @autoclosure @escaping () -> Content) {
    self.build = build
  }
  var body: Content {
    build()
  }
}
