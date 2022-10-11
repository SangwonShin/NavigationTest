//
//  ContentView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/11.
//

import SwiftUI

final class NavigationHelper: ObservableObject {
  @Published var view1To: Bool = false
  @Published var view2To: Bool = false
  @Published var view3To: Bool = false
  @Published var view4To: Bool = false
}

struct ContentView: View {
  @EnvironmentObject
  var navigationHelper: NavigationHelper
  
  var body: some View {
    NavigationView {
      NavigationLink(
        destination: NavigationLazyView(ContentView2()),
        isActive: $navigationHelper.view1To
      ) {
        Text("Hello, World!")
      }
      .isDetailLink(false)
      .navigationBarTitle("Root")
    }
  }
}

struct ContentView2: View {
  @EnvironmentObject
  var navigationHelper: NavigationHelper
  
  var body: some View {
    NavigationLink(
      destination: NavigationLazyView(ContentView3()),
      isActive: $navigationHelper.view2To
    ) {
      Text("Hello, World #2!")
    }
    .isDetailLink(false)
    .navigationBarTitle("Two")
  }
}

struct ContentView3: View {
  @EnvironmentObject
  var navigationHelper: NavigationHelper
  
  var body: some View {
    VStack {
      NavigationLink(
        destination: NavigationLazyView(ContentView4()),
        isActive: $navigationHelper.view3To
      ) {
        Text("Hello, World #3!")
      }
      
      Button(
        action: { navigationHelper.view1To = false }
      ){
        Text("Pop to root")
      }
      
      Button(
        action: { navigationHelper.view2To = false }
      ){
        Text("Pop to prev")
      }
    }.navigationBarTitle("Three")
  }
}

struct ContentView4: View {
  @EnvironmentObject
  var navigationHelper: NavigationHelper
  
  var body: some View {
    VStack {
      Text("Hello, World #4!")
      
      Button(
        action: {
          navigationHelper.view1To = false
          navigationHelper.view2To = false
          navigationHelper.view3To = false
          
        }
      ){
        Text("Pop to root")
      }
      
      Button(
        action: {
          navigationHelper.view2To = false
          navigationHelper.view3To = false
        }
      ){
        Text("Pop to 2")
      }
    }.navigationBarTitle("Four")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
