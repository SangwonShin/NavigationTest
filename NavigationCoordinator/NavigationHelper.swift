//
//  NavigationHelper.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/12.
//

import Combine
import SwiftUI

struct ViewDestination {
  let viewID: String
  var state: Bool
}

final class NavigationHelper: ObservableObject {
  @Published private var navigationPaths = [
    ViewDestination(viewID: "1", state: false),
    ViewDestination(viewID: "2", state: false),
    ViewDestination(viewID: "3", state: false),
    ViewDestination(viewID: "4", state: false)
  ]
  
  subscript(viewID: String) -> ViewDestination {
    get {
      for i in 0..<navigationPaths.count {
        if navigationPaths[i].viewID == viewID {
          return navigationPaths[i]
        }
      }
      fatalError("Can't Find ViewID")
    }
    set {
      for i in 0..<navigationPaths.count {
        if navigationPaths[i].viewID == viewID {
          navigationPaths[i] = newValue
          return
        }
      }
      fatalError("Can't Find ViewID")
    }
  }

  
  private func findIndex(viewID: String) -> Int? {
    for i in 0..<navigationPaths.count {
      if navigationPaths[i].viewID == viewID {
        return i
      }
    }
    return nil
  }
  
  func pop(viewID: String, _ n: Int = 1) {
    guard let index = findIndex(viewID: viewID) else {
      print("Can't find viewID")
      return
    }
    
    if index - n < 0 {
      print("Out of Index")
      return
    }
    
    navigationPaths[index - n].state = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      [weak self] in
      guard let self = self else { return }
      for i in index - n..<index {
        self.navigationPaths[i].state = false
      }
    }
  }
  
  func popRoot() {
    navigationPaths[0].state = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      [weak self] in
      guard let self = self else { return }
      for i in 0..<self.navigationPaths.count {
        self.navigationPaths[i].state = false
      }
    }
  }
}
