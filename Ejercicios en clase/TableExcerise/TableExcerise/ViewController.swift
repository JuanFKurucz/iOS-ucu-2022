//
//  ViewController.swift
//  TableExcerise
//
//  Created by Juan Francisco Kurucz on 7/4/22.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let names = ["German","Adrian","Gonzalo","Pedro","Juan","Lucas","Maximiliano","Otro","Otro mas","Algo mas","Ya se me","Acabo la creatividad","Test"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: NumberTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NumberTableViewCell.identifier)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NumberTableViewCell.identifier) as! NumberTableViewCell
        let name = names[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.mainLabel.text = "test \(name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Names"
    }
}


extension ViewController: NumberTableViewCellDelegate {
    
    
    func didTapAddButton(index: IndexPath?) {
        print("pressed \(String(describing: index?.row))")
    }
    
}
