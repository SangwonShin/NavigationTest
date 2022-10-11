//
//  CView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/07.
//

import SwiftUI

import NavigationViewKit

class CViewModel: ObservableObject {
  init() {
    print("CViewModel init")
  }
  
  deinit {
    print("CViewModel Deinit")
  }
}

struct CView: View {
  @Environment(\.navigationManager)
  var naviManager
  
  @StateObject
  var viewModel = CViewModel()
  
  init() {
    print("CView init")
  }
  
  var body: some View {
    VStack {
      Text("This is C")
        .font(.largeTitle)
      
      Button(
        action: {
          naviManager.wrappedValue.pushView(
            tag: ViewID.c.id,
            animated: true,
            view: { DView() }
          )
        },
        label: { Text("GO TO D") }
      )
      
      Button(
        action: {
          naviManager.wrappedValue.popToRoot(tag: ViewID.a.id, animated: true)
        },
        label: { Text("Pop to Root") }
      )
    }
    .navigationTitle("CView")
    .navigationBarTitleDisplayMode(.inline)
    .navigationViewManager(for: ViewID.c.id)
  }
}
