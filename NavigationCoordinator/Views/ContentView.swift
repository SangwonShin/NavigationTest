//
//  ContentView.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/11.
//

import Combine
import SwiftUI

final class NavigationHelper: ObservableObject {
  @Published var view1To: Bool = false
  @Published var view2To: Bool = false
  @Published var view3To: Bool = false
  @Published var view4To: Bool = false
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    bind()
  }
  
  func popTo(viewID: ViewID) {
    
  }
  
  func popRoot() {
    
  }
  
  // TODO: - 상위 depth로 pop하는 경우, 처리
  // FIXME: - 아래와 같은 구조에서 만약 navigaiton Depth가 100d이면 10초가 걸리는 문제
  func bind() {
    $view1To
      .dropFirst()
      .filter { $0 == false }
      .delay(for: 0.1, scheduler: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.view2To = false
      }.store(in: &cancellables)
    
    $view2To
      .dropFirst()
      .filter { $0 == false }
      .delay(for: 0.1, scheduler: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.view3To = false
      }.store(in: &cancellables)
    
    $view3To
      .dropFirst()
      .filter { $0 == false }
      .delay(for: 0.1, scheduler: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.view4To = false
      }.store(in: &cancellables)
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
          navigationHelper.view1To = false
        }
      ){
        Text("Pop to root")
      }
      
      Button(
        action: {
          navigationHelper.view2To = false
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
          navigationHelper.view1To = false
        }
      ){
        Text("Pop to root")
      }
      
      Button(
        action: {
          navigationHelper.view2To = false
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
