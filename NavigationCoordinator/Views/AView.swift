//
//  AView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/07.
//

import SwiftUI

import NavigationViewKit

class AViewModel: ObservableObject {
  init() {
    print("AViewModel init")
  }
  
  deinit {
    print("AViewModel Deinit")
  }
}

struct AView: View {
  @StateObject
  var viewModel = AViewModel()
  
  @State
  var goToB: Bool = false
  
  @Environment(\.navigationManager)
  var naviManager
  
  var body: some View {
    NavigationView {
      VStack {
        NavigationLink(
          isActive: $goToB,
          destination: {
            NavigationLazyView(BView(viewModel: BViewModel()))
          },
          label: { EmptyView() }
        )

        Button(
          action: { goToB = true },
          label: { Text("Go TO B") }
        )
        
//        Button(
//          action: {
//            naviManager.wrappedValue.pushView(
//              tag: ViewID.b.rawValue,
//              animated: true,
//              view: {
////                NavigationLazyView(BView(viewModel: BViewModel()))
//                BView(viewModel: BViewModel())
//              }
//            )
//          },
//          label: { Text("GO TO B") }
//        )
        
      }
      .navigationTitle("AView")
      .navigationBarTitleDisplayMode(.inline)
      
    }
    .navigationViewManager(for: ViewID.a.id)
  }
  
}
