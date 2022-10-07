//
//  CustomNavigationStack.swift
//  NavigationCoordinator
//
//  Created by 신상원 on 2022/10/07.
//

import SwiftUI
import Combine

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Custom NavigationLink
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

final class CustomNavigationLinkViewModel<CustomViewID>: ObservableObject where CustomViewID: Equatable {
  private weak var navigationStack: NavigationStack<CustomViewID>?
  /// `viewId` is used to find a `CustomNavigationLinkViewModel` in the `NavigationStack`
  let viewId = UUID().uuidString
  
  /// `customId` is used to mark a `CustomNavigationLink` in the `NavigationStack`. This is kind of external id.
  /// In `NavigationStack` we always prefer to use `viewId`. But from time to time we need to implement `pop several views`
  /// and that is the purpose of the `customId`
  /// Developer can just create a link with `customId` e.g. `navigationStack.navigationLink(customId: "123") { .. }`
  /// And to pop directly to  view `"123"` should use `navigationStack.popToLast(customId: "123")`
  let customId: CustomViewID?
  
  @Published var isActive = false {
    didSet { navigationStack?.updated(linkViewModel: self) }
  }
  
  init (navigationStack: NavigationStack<CustomViewID>, customId: CustomViewID? = nil) {
    self.navigationStack = navigationStack
    self.customId = customId
  }
}

extension CustomNavigationLinkViewModel: Equatable {
  static func == (lhs: CustomNavigationLinkViewModel, rhs: CustomNavigationLinkViewModel) -> Bool {
    lhs.viewId == rhs.viewId && lhs.customId == rhs.customId
  }
}

struct CustomNavigationLink<Label, Destination, CustomViewID>: View where Label: View, Destination: View, CustomViewID: Equatable {
  
  /// Link `ViewModel` where all states are stored
  @StateObject var viewModel: CustomNavigationLinkViewModel<CustomViewID>
  
  let destination: () -> Destination
  let label: () -> Label
  
  var body: some View {
    NavigationLink(isActive: $viewModel.isActive, destination: destination, label: label)
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: NavigationStack
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class NavigationStack<CustomViewID>: ObservableObject where CustomViewID: Equatable {
  
  typealias Link = WeakReference<CustomNavigationLinkViewModel<CustomViewID>>
  private var linkedList = LinkedList<Link>()
  
  func navigationLink<Label, Destination>(customId: CustomViewID? = nil,
                                          @ViewBuilder destination: @escaping () -> Destination,
                                          @ViewBuilder label: @escaping () -> Label)
  -> some View where Label: View, Destination: View {
    createNavigationLink(customId: customId, destination: destination, label: label)
  }
  
  private func createNavigationLink<Label, Destination>(customId: CustomViewID? = nil,
                                                        @ViewBuilder destination: @escaping () -> Destination,
                                                        @ViewBuilder label: @escaping () -> Label)
  -> CustomNavigationLink<Label, Destination, CustomViewID> where Label: View, Destination: View {
    .init(viewModel: CustomNavigationLinkViewModel(navigationStack: self, customId: customId),
          destination: destination,
          label: label)
  }
}

// MARK: Nested Types

extension NavigationStack {
  /// To avoid retain cycle it is important to store weak reference to the `CustomNavigationLinkViewModel`
  final class WeakReference<T> where T: AnyObject {
    private(set) weak var weakReference: T?
    init(value: T) { self.weakReference = value }
    deinit { print("deinited WeakReference") }
  }
}

// MARK: Searching

extension NavigationStack {
  private func last(where condition: (Link) -> Bool) -> LinkedList<Link>.Node? {
    var node = linkedList.last
    while(node != nil) {
      if let node = node, condition(node.value) {
        return node
      }
      node = node?.previous
    }
    return nil
  }
}

// MARK: Binding

extension NavigationStack {
  fileprivate func updated(linkViewModel: CustomNavigationLinkViewModel<CustomViewID>) {
    guard linkViewModel.isActive else {
      switch linkedList.head?.value.weakReference {
      case nil: break
      case linkViewModel: linkedList.removeAll()
      default:
        last (where: { $0.weakReference === linkViewModel })?.previous?.next = nil
      }
      return
    }
    linkedList.append(WeakReference(value: linkViewModel))
  }
}

// MARK: pop functionality

extension NavigationStack {
  func popToRoot() {
    linkedList.head?.value.weakReference?.isActive = false
  }
  
  func pop() {
    linkedList.last?.value.weakReference?.isActive = false
  }
  
  func popToLast(customId: CustomViewID) {
    last (where: { $0.weakReference?.customId == customId })?.value.weakReference?.isActive = false
  }
}

#if DEBUG

extension NavigationStack {
  var isEmpty: Bool { linkedList.isEmpty }
  var count: Int { linkedList.count }
  func testCreateNavigationLink<Label, Destination>(viewModel: CustomNavigationLinkViewModel<CustomViewID>,
                                                    @ViewBuilder destination: @escaping () -> Destination,
                                                    @ViewBuilder label: @escaping () -> Label)
  -> CustomNavigationLink<Label, Destination, CustomViewID> where Label: View, Destination: View {
    .init(viewModel: viewModel, destination: destination, label: label)
  }
  
}
#endif


public final class LinkedList<T> {
  
  /// Linked List's Node Class Declaration
  public class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode?
    weak var previous: LinkedListNode?
    
    public init(value: T) {
      self.value = value
    }
  }
  
  /// Typealiasing the node class to increase readability of code
  public typealias Node = LinkedListNode<T>
  
  
  /// The head of the Linked List
  private(set) var head: Node?
  
  /// Computed property to iterate through the linked list and return the last node in the list (if any)
  public var last: Node? {
    guard var node = head else {
      return nil
    }
    
    while let next = node.next {
      node = next
    }
    return node
  }
  
  /// Computed property to check if the linked list is empty
  public var isEmpty: Bool {
    return head == nil
  }
  
  /// Computed property to iterate through the linked list and return the total number of nodes
  public var count: Int {
    guard var node = head else {
      return 0
    }
    
    var count = 1
    while let next = node.next {
      node = next
      count += 1
    }
    return count
  }
  
  /// Default initializer
  public init() {}
  
  
  /// Subscript function to return the node at a specific index
  ///
  /// - Parameter index: Integer value of the requested value's index
  public subscript(index: Int) -> T {
    let node = self.node(at: index)
    return node.value
  }
  
  /// Function to return the node at a specific index. Crashes if index is out of bounds (0...self.count)
  ///
  /// - Parameter index: Integer value of the node's index to be returned
  /// - Returns: LinkedListNode
  public func node(at index: Int) -> Node {
    assert(head != nil, "List is empty")
    assert(index >= 0, "index must be greater or equal to 0")
    
    if index == 0 {
      return head!
    } else {
      var node = head!.next
      for _ in 1..<index {
        node = node?.next
        if node == nil {
          break
        }
      }
      
      assert(node != nil, "index is out of bounds.")
      return node!
    }
  }
  
  /// Append a value to the end of the list
  ///
  /// - Parameter value: The data value to be appended
  public func append(_ value: T) {
    let newNode = Node(value: value)
    append(newNode)
  }
  
  /// Append a copy of a LinkedListNode to the end of the list.
  ///
  /// - Parameter node: The node containing the value to be appended
  public func append(_ node: Node) {
    let newNode = node
    if let lastNode = last {
      newNode.previous = lastNode
      lastNode.next = newNode
    } else {
      head = newNode
    }
  }
  
  /// Append a copy of a LinkedList to the end of the list.
  ///
  /// - Parameter list: The list to be copied and appended.
  public func append(_ list: LinkedList) {
    var nodeToCopy = list.head
    while let node = nodeToCopy {
      append(node.value)
      nodeToCopy = node.next
    }
  }
  
  /// Insert a value at a specific index. Crashes if index is out of bounds (0...self.count)
  ///
  /// - Parameters:
  ///   - value: The data value to be inserted
  ///   - index: Integer value of the index to be insterted at
  public func insert(_ value: T, at index: Int) {
    let newNode = Node(value: value)
    insert(newNode, at: index)
  }
  
  /// Insert a copy of a node at a specific index. Crashes if index is out of bounds (0...self.count)
  ///
  /// - Parameters:
  ///   - node: The node containing the value to be inserted
  ///   - index: Integer value of the index to be inserted at
  public func insert(_ newNode: Node, at index: Int) {
    if index == 0 {
      newNode.next = head
      head?.previous = newNode
      head = newNode
    } else {
      let prev = node(at: index - 1)
      let next = prev.next
      newNode.previous = prev
      newNode.next = next
      next?.previous = newNode
      prev.next = newNode
    }
  }
  
  /// Insert a copy of a LinkedList at a specific index. Crashes if index is out of bounds (0...self.count)
  ///
  /// - Parameters:
  ///   - list: The LinkedList to be copied and inserted
  ///   - index: Integer value of the index to be inserted at
  public func insert(_ list: LinkedList, at index: Int) {
    guard !list.isEmpty else { return }
    
    if index == 0 {
      list.last?.next = head
      head = list.head
    } else {
      let prev = node(at: index - 1)
      let next = prev.next
      
      prev.next = list.head
      list.head?.previous = prev
      
      list.last?.next = next
      next?.previous = list.last
    }
  }
  
  /// Function to remove all nodes/value from the list
  public func removeAll() {
    head = nil
  }
  
  /// Function to remove a specific node.
  ///
  /// - Parameter node: The node to be deleted
  /// - Returns: The data value contained in the deleted node.
  @discardableResult public func remove(node: Node) -> T {
    let prev = node.previous
    let next = node.next
    
    if let prev = prev {
      prev.next = next
    } else {
      head = next
    }
    next?.previous = prev
    
    node.previous = nil
    node.next = nil
    return node.value
  }
  
  /// Function to remove the last node/value in the list. Crashes if the list is empty
  ///
  /// - Returns: The data value contained in the deleted node.
  @discardableResult public func removeLast() -> T {
    assert(!isEmpty)
    return remove(node: last!)
  }
  
  /// Function to remove a node/value at a specific index. Crashes if index is out of bounds (0...self.count)
  ///
  /// - Parameter index: Integer value of the index of the node to be removed
  /// - Returns: The data value contained in the deleted node
  @discardableResult public func remove(at index: Int) -> T {
    let node = self.node(at: index)
    return remove(node: node)
  }
}

//: End of the base class declarations & beginning of extensions' declarations:
// MARK: - Extension to enable the standard conversion of a list to String
extension LinkedList: CustomStringConvertible {
  public var description: String {
    var s = "["
    var node = head
    while let nd = node {
      s += "\(nd.value)"
      node = nd.next
      if node != nil { s += ", " }
    }
    return s + "]"
  }
}

// MARK: - Extension to add a 'reverse' function to the list
extension LinkedList {
  public func reverse() {
    var node = head
    while let currentNode = node {
      node = currentNode.next
      swap(&currentNode.next, &currentNode.previous)
      head = currentNode
    }
  }
}

// MARK: - An extension with an implementation of 'map' & 'filter' functions
extension LinkedList {
  public func map<U>(transform: (T) -> U) -> LinkedList<U> {
    let result = LinkedList<U>()
    var node = head
    while let nd = node {
      result.append(transform(nd.value))
      node = nd.next
    }
    return result
  }
  
  public func filter(predicate: (T) -> Bool) -> LinkedList<T> {
    let result = LinkedList<T>()
    var node = head
    while let nd = node {
      if predicate(nd.value) {
        result.append(nd.value)
      }
      node = nd.next
    }
    return result
  }
}

// MARK: - Extension to enable initialization from an Array
extension LinkedList {
  convenience init(array: Array<T>) {
    self.init()
    
    array.forEach { append($0) }
  }
}

// MARK: - Extension to enable initialization from an Array Literal
extension LinkedList: ExpressibleByArrayLiteral {
  public convenience init(arrayLiteral elements: T...) {
    self.init()
    
    elements.forEach { append($0) }
  }
}

// MARK: - Collection
extension LinkedList: Collection {
  
  public typealias Index = LinkedListIndex<T>
  
  /// The position of the first element in a nonempty collection.
  ///
  /// If the collection is empty, `startIndex` is equal to `endIndex`.
  /// - Complexity: O(1)
  public var startIndex: Index {
    get {
      return LinkedListIndex<T>(node: head, tag: 0)
    }
  }
  
  /// The collection's "past the end" position---that is, the position one
  /// greater than the last valid subscript argument.
  /// - Complexity: O(n), where n is the number of elements in the list. This can be improved by keeping a reference
  ///   to the last node in the collection.
  public var endIndex: Index {
    get {
      if let h = self.head {
        return LinkedListIndex<T>(node: h, tag: count)
      } else {
        return LinkedListIndex<T>(node: nil, tag: startIndex.tag)
      }
    }
  }
  
  public subscript(position: Index) -> T {
    get {
      return position.node!.value
    }
  }
  
  public func index(after idx: Index) -> Index {
    return LinkedListIndex<T>(node: idx.node?.next, tag: idx.tag + 1)
  }
}

// MARK: - Collection Index
/// Custom index type that contains a reference to the node at index 'tag'
public struct LinkedListIndex<T>: Comparable {
  fileprivate let node: LinkedList<T>.LinkedListNode<T>?
  fileprivate let tag: Int
  
  public static func==<T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
    return (lhs.tag == rhs.tag)
  }
  
  public static func< <T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
    return (lhs.tag < rhs.tag)
  }
}
