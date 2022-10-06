//
//  BView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/06.
//

import SwiftUI

struct BView: View {
  @Binding
  var prevPage: Bool
  
  init(_ prev: Binding<Bool>) {
    self._prevPage = prev
  }
  
  var body: some View {
    VStack {
      Button(
        action: { self.prevPage = false },
        label: { Text("Back") }
      )
    }
  }
}
