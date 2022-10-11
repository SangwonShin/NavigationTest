//
//  CView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/07.
//

import SwiftUI

struct CView: View {
  @EnvironmentObject
  var navigationStack: NavigationStack<ViewID>
  
  var body: some View {
    VStack {
      Text("This is C")
        .font(.largeTitle)
      
      navigationStack.navigationLink(
        customId: .c,
        destination: { DView() },
        label: { Text("Go TO D") }
      )
      
      Button(
        action: { navigationStack.popToRoot() },
        label: { Text("Pop to Root") }
      )
      
      Button(
        action: { navigationStack.popToLast(customId: .b) },
        label: { Text("Go Back To B") }
      )
      
      Button(
        action: { navigationStack.pop() },
        label: { Text("pop") }
      )

    }
    
  }
}
