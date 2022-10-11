//
//  BView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/07.
//

import SwiftUI

import NavigationViewKit

class BViewModel: ObservableObject {
  init() {
    print("BViewModel init")
  }
  
  deinit {
    print("BViewModel Deinit")
  }
}

struct BView: View {
  @Environment(\.navigationManager)
  var naviManager
  
  @ObservedObject
  var viewModel: BViewModel
  
  @State
  var goToC: Bool = false
  
  init(viewModel: BViewModel) {
    print("BView init")
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack {
      Text("This is B")
        .font(.largeTitle)
      
//      Button(
//        action: {
//          naviManager.wrappedValue.pushView(
//            tag: ViewID.b.id,
//            animated: true,
//            view: {
//              NavigationLazyView(CView())
////              CView()
//            }
//          )
//        },
//        label: { Text("GO TO C") }
//      )
      
      NavigationLink(
        isActive: $goToC,
        destination: {
          NavigationLazyView(CView())
        },
        label: { EmptyView() }
      )

      Button(
        action: { goToC = true },
        label: { Text("Go TO C") }
      )
      
      Button(
        action: {
          naviManager.wrappedValue.popToRoot(tag: ViewID.a.id, animated: true)
        },
        label: { Text("Pop to Root") }
      )
    }
    .navigationTitle("BView")
    .navigationBarTitleDisplayMode(.inline)
    .navigationViewManager(for: ViewID.b.id)
  }
}
