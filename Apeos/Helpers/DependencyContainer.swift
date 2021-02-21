import Foundation

typealias ModuleDependencies =
    HasDataManager &
    HasMainQueue

final class DependencyContainer: ModuleDependencies {
    lazy var dataManager: DataManagerContract = DataManager.shared
    lazy var mainQueue: DispatchQueue = DispatchQueue.main
}
