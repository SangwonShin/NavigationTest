//
//  AView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/07.
//

import SwiftUI

import NavigationStack

struct RootView: View {
  var body: some View {
    NavigationStackView {
      AView()
    }
  }
}

struct AView: View {
  @State
  var goToNextView: Bool = false
  
  @EnvironmentObject
  var navigationHelper: NavigationHelper
  
  var body: some View {
    
  NavigationView {
    VStack {
      NavigationLink(
        isActive: $navigationHelper.goToA,
        destination: { BView() },
        label: { EmptyView() }
      )
      
      Button(
        action: {
          navigationHelper.goToA = true
        },
        label: {
          Text("GO TO B")
            .font(.largeTitle)
        }
      )
    }
  }
}
}
