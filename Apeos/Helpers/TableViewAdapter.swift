import Foundation
import UIKit

final class TableViewAdapter<Cell, Item>: NSObject, UITableViewDataSource, UITableViewDelegate where Cell: UITableViewCell {
    typealias ItemProvider = (_ tableView: UITableView, _ indexPath: IndexPath, _ item: Item) -> Cell?
    typealias ItemSelected = (_ tableView: UITableView, _ indexPath: IndexPath, _ item: Item) -> Void
    typealias ItemPagination = () -> Void
    
    var itemProvider: ItemProvider?
    var itemSelected: ItemSelected?
    var itemPagination: ItemPagination?
    
    private var data = [Item]()
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func add(items: [Item]) {
        data.append(contentsOf: items)
    }
    
    func update(items: [Item]) {
        data = items
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row]
        
        guard let cell = itemProvider?(tableView, indexPath, item) else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        itemSelected?(tableView, indexPath, item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentSizeHeight = scrollView.contentSize.height
        
        if offsetY > contentSizeHeight - scrollView.frame.size.height {
            itemPagination?()
        }
    }
}
