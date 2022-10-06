//
//  ContentView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/06.
//

import SwiftUI

struct ContentView: View {
  @State
  var isNext: Bool = false
  
  var body: some View {
    NavigationView {
      VStack {
        NavigationLink(
          isActive: $isNext,
          destination: {
            AView($isNext)
//            bView(dismiss: $isNext)
          },
          label: { }
        )
        
        Button(
          action: { isNext = true },
          label: {
            Text("Press")
              .font(.largeTitle)
              .padding()
              .background(.blue)
          }
        )
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
