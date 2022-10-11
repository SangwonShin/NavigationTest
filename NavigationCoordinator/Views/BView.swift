//
//  BView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/07.
//

import SwiftUI

struct BView: View {
  @EnvironmentObject
  var navigationStack: NavigationStack<ViewID>
  
  var body: some View {
    VStack {
      Text("This is B")
        .font(.largeTitle)
      
      navigationStack.navigationLink(
        customId: ViewID.b,
        destination: { CView() },
        label: { Text("GO TO C") }
      )
      
      Button(
        action: { navigationStack.pop() },
        label: { Text("Pop to Root") }
      )
    }
  }
}
