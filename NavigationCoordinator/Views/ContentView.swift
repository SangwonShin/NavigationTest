//
//  ContentView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/11.
//

import Combine
import SwiftUI

final class NavigationHelper: ObservableObject {
  @Published var view1To: Bool = false {
    didSet {
      print("Changed1 OldValue:", oldValue)
      print("Changed1 NewValue:", self.view1To)
    }
  }
  
  @Published var view2To: Bool = false {
    didSet {
      print("Changed2 OldValue:", oldValue)
      print("Changed2 NewValue:", self.view1To)
    }
  }
  
  @Published var view3To: Bool = false {
    didSet {
      print("Changed3 OldValue:", oldValue)
      print("Changed3 NewValue:", self.view1To)
    }
  }
  
  @Published var view4To: Bool = false {
    didSet {
      print("Changed4 OldValue:", oldValue)
      print("Changed4 NewValue:", self.view1To)
    }
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
  }
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
      .isDetailLink(false)
      
      Button(
        action: {
          DispatchQueue.main.async {
            navigationHelper.view1To = false
//            navigationHelper.view2To = false
          }
        }
      ){
        Text("Pop to root")
      }
      
      Button(
        action: {
          DispatchQueue.main.async {
            navigationHelper.view2To = false
          }
        }
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
        action: {
          DispatchQueue.main.async {
            print("1")
            navigationHelper.view1To = false
            print("2")
            navigationHelper.view2To = false
            print("3")
            navigationHelper.view3To = false
          }
        }
      ){
        Text("Pop to root")
      }
      
      Button(
        action: {
          DispatchQueue.main.async {
            navigationHelper.view2To = false
            navigationHelper.view3To = false
          }
        }
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
