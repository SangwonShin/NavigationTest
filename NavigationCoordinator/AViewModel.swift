//
//  AViewModel.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/06.
//

// MARK: - Deinit 시점 확인
import Foundation

class AViewModel: ObservableObject {
  @Published var test: String = ""
  
  init() {
    print("AViewModel init")
  }
  
  deinit {
    print("AViewModel deinit")
  }
}


class BViewModel: ObservableObject {
  @Published var test: String = ""
  
  init() {
    print("BViewModel init")
  }
  
  deinit {
    print("BViewModel deinit")
  }
}
