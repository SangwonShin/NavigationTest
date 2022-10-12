//
//  ContentView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/11.
//

import Combine
import SwiftUI

struct ContentView: View {
  @StateObject
  var coordinator = NavigationCoordinator.shared
  
  let viewID = "11"
  
  var body: some View {
    NavigationView {
      VStack {
        // FIXME: - View 생명주기에 의해서 발생하는 문제
        if coordinator.appendState(viewID: viewID) == false {
          NavigationLink(
            isActive: $coordinator[viewID].state,
            destination: { NavigationLazyView(ContentView2()) },
            label: { EmptyView() }
          ).isDetailLink(false)
        }
        
        Button(
          action: { coordinator[viewID].state = true },
          label: { Text("GO TO B") }
        )
      }
      .navigationTitle("A")
    }
  }
}

struct ContentView2: View {
  @StateObject
  var coordinator = NavigationCoordinator.shared
  
  let viewID = "22"
  
  var body: some View {
    VStack {
      if coordinator.appendState(viewID: viewID) == false {
        NavigationLink(
          isActive: $coordinator[viewID].state,
          destination: { NavigationLazyView(ContentView3()) },
          label: { EmptyView() }
        ).isDetailLink(false)
      }
      
      Button(
        action: { coordinator[viewID].state = true },
        label: { Text("GO TO C") }
      )
      
      Button(
        action: { coordinator.pop(viewID: viewID) } ,
        label: { Text("GO Prev") }
      )
    }
    .navigationBarTitle("B")
  }
}

struct ContentView3: View {
  @StateObject
  var coordinator = NavigationCoordinator.shared
  
  let viewID = "33"
  
  var body: some View {
    VStack {
      if coordinator.appendState(viewID: viewID) == false {
        NavigationLink(
          isActive: $coordinator[viewID].state,
          destination: { NavigationLazyView(ContentView4()) },
          label: { EmptyView() }
        ).isDetailLink(false)
      }
      
      Button(
        action: { coordinator[viewID].state = true },
        label: { Text("GO TO D") }
      )
      
      Button(
        action: { coordinator.popRoot() }
      ){
        Text("Pop to root")
      }
      
      Button(
        action: { coordinator.pop(viewID: viewID) }
      ){
        Text("Pop to prev")
      }
    }
    .navigationBarTitle("Three")
  }
}

struct ContentView4: View {
  @StateObject
  var coordinator = NavigationCoordinator.shared
  
  let viewID = "44"
  
  var body: some View {
    VStack {
      Text("Hello, World #4!")
      
      Button(
        action: { coordinator.popRoot() }
      ){
        Text("Pop to root")
      }
      
      Button(
        action: { coordinator.pop(viewID: viewID, 2) }
      ){
        Text("Pop to 2")
      }
    }
    .navigationBarTitle("Four")
    .onAppear {
      let _ = coordinator.appendState(viewID: viewID)
    } // MARK: - navigationLink가 없는 경우
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
