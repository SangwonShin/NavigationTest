//
//  DView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/11.
//

import SwiftUI

import NavigationViewKit

class DViewModel: ObservableObject {
  init() {
    print("DViewModel init")
  }
  
  deinit {
    print("DViewModel Deinit")
  }
}

struct DView: View {
  @Environment(\.navigationManager)
  var naviManager
  
  @StateObject
  var viewModel = DViewModel()
  
  init() {
    print("DView init")
  }
  
  var body: some View {
    VStack(spacing: 18) {
      Text("This is D")
        .font(.largeTitle)
      
      Button(
        action: {
          naviManager.wrappedValue.pushView(
            tag: ViewID.d.id,
            animated: true,
            view: { EView() }
          )
        },
        label: { Text("GO TO E") }
      )
      
      Button(
        action: {
          naviManager.wrappedValue.popToRoot(tag: ViewID.a.id, animated: true)
        },
        label: { Text("Pop to Root") }
      )
      
      Button(
        action: {
          naviManager.wrappedValue.popToRoot(tag: ViewID.b.id, animated: true)
        },
        label: { Text("Pop to B") }
      )
      
      Button(
        action: {
          naviManager.wrappedValue.popToRoot(tag: ViewID.c.id, animated: true)
        },
        label: { Text("Pop to C") }
      )
    }
    .navigationTitle("DView")
    .navigationBarTitleDisplayMode(.inline)
    .navigationViewManager(for: ViewID.d.id)
  }
}

