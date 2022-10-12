//
//  NavigationCoordinator.swift
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


final class NavigationCoordinator: ObservableObject {
  public static let shared = NavigationCoordinator()
  
  private init() { }
  
  @Published private var navigationPaths: [ViewDestination] = [] {
    didSet {
      print(self.navigationPaths)
    }
  }
  
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
  
  func appendState(viewID: String) -> Bool {
    // MARK: - 중복을 지우지 않으면 NavigationLink 생성 시 무한루프에 빠지는 문제점
    for path in navigationPaths {
      if path.viewID == viewID { return false }
    }
    navigationPaths.append(ViewDestination(viewID: viewID, state: false))
    return self[viewID].viewID == viewID ? true : false
  }
  
//  @ViewBuilder
//  func pushView(
//    viewID: String,
//    destination: some View
//  ) -> some View {
//    VStack {
//      if appendState(viewID: viewID) {
//        NavigationLink(
//          isActive: Binding<Bool>.init(
//            get: { self[viewID].state },
//            set: { self[viewID].state = $0 }
//          ),
//          destination: { destination },
//          label: { EmptyView() }
//        )
//      } else {
//        EmptyView()
//      }
//    }
//  }
  
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
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      guard let self = self else { return }
      // index의 값은 이미 false, 아직 NavigationLink를 통해 다음 view로 가지 않았기 때문에
      for i in index - n..<index {
        self.navigationPaths[i].state = false
      }
      self.navigationPaths.removeLast(n) // FIXME: - n이 1인 경우에는 왜 지워지지 않는가?
    }
  }
  
  func popRoot() {
    navigationPaths[0].state = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      guard let self = self else { return }
      for i in 0..<self.navigationPaths.count {
        self.navigationPaths[i].state = false
      }
      self.navigationPaths = []
    }
    self.navigationPaths = []
  }
  
}
