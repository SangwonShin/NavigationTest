//
//  AView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/06.
//

import SwiftUI

struct AView: View {
  @State
  var aViewNext: Bool = false
  
  @Binding
  var prevPage: Bool
  
  init(_ prev: Binding<Bool>) {
    self._prevPage = prev
  }
  
  var body: some View {
    VStack {
      NavigationLink(
        isActive: $aViewNext,
        destination: {
//          BView($aViewNext)
          CView(
            prev: $aViewNext,
            root: $prevPage
          )
        },
        label: { }
      )
      
      Button(
        action: { self.aViewNext = true },
        label: {
          Text("Go Next")
        }
      )
      
      Button(
        action: { self.prevPage = false },
        label: { Text("Back") }
      )
    }
  }
}
