//
//  CView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/06.
//

import SwiftUI

struct CView: View {
  @Binding
  var prevPage: Bool
  
  @Binding
  var backRoot: Bool
  
  init(
    prev: Binding<Bool>,
    root: Binding<Bool>
  ) {
    self._prevPage = prev
    self._backRoot = root
  }
  
  var body: some View {
    VStack {
      Button(
        action: {
          self.prevPage = false
        },
        label: {
          Text("Back Prev")
            .font(.largeTitle)
        }
      )
      
      Button(
        action: {
          self.backRoot = false
        },
        label: {
          Text("Back Root")
            .font(.largeTitle)
        }
      )
    }
  }
  
}
