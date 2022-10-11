//
//  AView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/07.
//

import SwiftUI

import NavigationStack

struct AView: View {
  @EnvironmentObject
  var navigationStack: NavigationStack<ViewID>
  
  var body: some View {
    NavigationView {
      navigationStack.navigationLink(
        customId: .a,
        destination: { BView() },
        label: { Text("GO To B") }
      )
    }
  }
  
}
