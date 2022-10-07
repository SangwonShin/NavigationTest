//
//  CView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/07.
//

import SwiftUI

struct CView: View {
  @EnvironmentObject
  var navigationHelper: NavigationHelper
  
  var body: some View {
    VStack {
      Text("TEST")
      Button(
        action: { navigationHelper.goToB = false },
        label: {
          Text("GO Back To A")
            .font(.largeTitle)
        }
      )

      Button(
        action: { navigationHelper.goToA = false },
        label: {
          Text("GO Back to B")
            .font(.largeTitle)
        }
      )
    }
    
  }
}
