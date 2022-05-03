//
//  ViewController.swift
//  CoreDataRelationship
//
//  Created by Megi Sila on 2.5.22.
//  Copyright © 2022 Megi Sila. All rights reserved.
//

import UIKit
import CoreData

var singers = [Singer]()

class SingerVC: UIViewController {
    let tableView = UITableView()
    let navigationBar = UINavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        singers = DataManager.shared.singers()
    }
    
    func setupUI() {
        title = "Singers"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "singerCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(navigationBar)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSinger))
    }
    
    @objc func addSinger(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Enter new singer", message: "", preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .default) { (action) in
            let singer = DataManager.shared.singer(name: textfield.text ?? "")
            singers.append(singer)
            DataManager.shared.save()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: Beyonce"
            textfield = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableView extensions
extension SingerVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singer = singers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "singerCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = singer.name
        cell.accessoryType = .disclosureIndicator
        tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songVC = SongsVC(index: indexPath.row)
        navigationController?.pushViewController(songVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editSingerAction(indexPath: indexPath)
            completionHandler(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteSingerAction(indexPath: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    private func editSingerAction(indexPath: IndexPath) {
        let singer = singers[indexPath.row]
        var nameTextField = UITextField()

        let alert = UIAlertController(title: "Edit singer", message: "", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            singer.setValue(nameTextField.text ?? "", forKey: "name")
            DataManager.shared.save()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: Beyonce"
            alertTextField.text = singer.name
            nameTextField = alertTextField
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteSingerAction(indexPath: IndexPath) {
        let singer = singers[indexPath.row]
        let areYouSureAlert = UIAlertController(title: "Are you sure you want to delete this singer?", message: "", preferredStyle: .alert)
        let yesDeleteAction = UIAlertAction(title: "Yes", style: .destructive) { [self] (action) in
            DataManager.shared.deleteSinger(singer: singer)
            singers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
        let noDeleteAction = UIAlertAction(title: "No", style: .default) { (action) in
            //do nothing
        }
        areYouSureAlert.addAction(noDeleteAction)
        areYouSureAlert.addAction(yesDeleteAction)
        self.present(areYouSureAlert, animated: true, completion: nil)
    }
}


