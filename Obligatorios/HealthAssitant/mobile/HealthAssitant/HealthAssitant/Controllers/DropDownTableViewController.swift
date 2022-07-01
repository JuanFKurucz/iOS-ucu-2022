//
//  DropDownTableViewController.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 30/6/22.
//

import UIKit


protocol DropDownTableViewControllerDelegate {
    func getSelected(element: Int)
}

class DropDownTableViewController: UITableViewController {
    static let identifier : String = "DropDownTableViewController"

    
    var delegate : DropDownTableViewControllerDelegate?;
    var elements : [String] = [];
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    
        self.tableView.register(UINib(nibName: DropDownTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DropDownTableViewCell.identifier)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return elements.count+1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTableViewCell.identifier) as! DropDownTableViewCell
        if (indexPath.row >= elements.count) {
            cell.dropDownTextLabel.text = "Remove selection"
        } else {
            cell.dropDownTextLabel.text = self.elements[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at \(indexPath.row)")
        delegate?.getSelected(element: indexPath.row)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
