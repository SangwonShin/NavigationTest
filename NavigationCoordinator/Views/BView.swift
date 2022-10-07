//
//  BView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/07.
//

import SwiftUI

struct BView: View {

  @EnvironmentObject
  var navigationHelper: NavigationHelper
  
  var body: some View {
    VStack {
      NavigationLink(
        isActive: $navigationHelper.goToB,
        destination: { CView() },
        label: { EmptyView() }
      )
      
      Button(
        action: {
          self.navigationHelper.goToB = true
//          self.navigationHelper.goToA = true
        },
        label: {
          Text("GO TO C")
            .font(.largeTitle)
        }
      )
      
      Button(
        action: { self.navigationHelper.goToA = false },
        label: {
          Text("GO Back A")
            .font(.largeTitle)
        }
      )
    }
  }
}
