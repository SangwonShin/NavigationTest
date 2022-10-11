//
//  EView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/11.
//

import SwiftUI

import NavigationViewKit

class EViewModel: ObservableObject {
  init() {
    print("DViewModel init")
  }
  
  deinit {
    print("DViewModel Deinit")
  }
}

struct EView: View {
  @Environment(\.navigationManager)
  var naviManager
  
  @StateObject
  var viewModel = DViewModel()
  
  init() {
    print("EView init")
  }
  
  var body: some View {
    VStack(spacing: 18){
      Text("This is E")
        .font(.largeTitle)
      
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
      
      Button(
        action: {
          naviManager.wrappedValue.popToRoot(tag: ViewID.d.id, animated: true)
//          naviManager.wrappedValue.delController(tag: ViewID.d.id)
        },
        label: { Text("Pop to D") }
      )
    }
    .navigationTitle("EView")
    .navigationBarTitleDisplayMode(.inline)
    .navigationViewManager(for: ViewID.e.id)
  }
}


