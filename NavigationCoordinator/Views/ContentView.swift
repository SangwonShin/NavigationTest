//
//  ContentView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/11.
//

import Combine
import SwiftUI

struct ContentView: View {
  @EnvironmentObject
  var navigationHelper: NavigationHelper
  
  var body: some View {
    NavigationView {
      NavigationLink(
        isActive: $navigationHelper["1"].state ,
        destination: { NavigationLazyView(ContentView2()) },
        label: { Text("Hello, World!") }
      )
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
      isActive: $navigationHelper["2"].state ,
      destination: { NavigationLazyView(ContentView3()) },
      label: { Text("Hello, World #2!") }
    )
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
        isActive: $navigationHelper["3"].state ,
        destination: { NavigationLazyView(ContentView4()) },
        label: { Text("Hello, World #3!") }
      )
      .isDetailLink(false)
      
      Button(
        action: { navigationHelper.popRoot() }
      ){
        Text("Pop to root")
      }
      
      Button(
        action: { navigationHelper.pop(viewID: "3", 1) }
      ){
        Text("Pop to prev")
      }
    }
    .navigationBarTitle("Three")
  }
}

struct ContentView4: View {
  @EnvironmentObject
  var navigationHelper: NavigationHelper
  
  var body: some View {
    VStack {
      Text("Hello, World #4!")
      
      Button(
        action: { navigationHelper.popRoot() }
      ){
        Text("Pop to root")
      }
      
      Button(
        action: { navigationHelper.pop(viewID: "4", 2) }
      ){
        Text("Pop to 2")
      }
    }
    .navigationBarTitle("Four")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
