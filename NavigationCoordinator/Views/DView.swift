//
//  DView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/11.
//

import SwiftUI

struct DView: View {
  @EnvironmentObject
  var navigationStack: NavigationStack<ViewID>
  
  var body: some View {
    VStack {
      Text("This is D")
        .font(.largeTitle)
      
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

