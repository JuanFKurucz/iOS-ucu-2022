import UIKit

protocol DropDownTableViewControllerDelegate {
    func getSelected(element: Int)
}

class DropDownTableViewController: UITableViewController {
    static let identifier: String = "DropDownTableViewController"

    var delegate: DropDownTableViewControllerDelegate?
    var elements: [String] = []
    @IBOutlet var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: DropDownTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DropDownTableViewCell.identifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return elements.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTableViewCell.identifier) as! DropDownTableViewCell
        if indexPath.row >= elements.count {
            cell.dropDownTextLabel.text = "Remove selection"
        } else {
            cell.dropDownTextLabel.text = elements[indexPath.row]
        }
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.getSelected(element: indexPath.row)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
