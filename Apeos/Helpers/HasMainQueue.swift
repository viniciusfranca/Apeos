import Foundation

protocol HasMainQueue {
    var mainQueue: DispatchQueue { get }
}
