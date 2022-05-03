//
//  SongsVC.swift
//  CoreDataRelationship
//
//  Created by Megi Sila on 2.5.22.
//  Copyright © 2022 Megi Sila. All rights reserved.
//

import UIKit

class SongsVC: UIViewController {
    var songs = [Song]()
    var index = Int()
    var singer: Singer?
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let singer = singer {
            songs = DataManager.shared.songs(singer: singer)
        }
        tableView.reloadData()
    }
    
    init(index: Int) {
        self.index = index
        singer = singers[index]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        title = singers[index].name
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "songCell")
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSong))
    }
    
    @objc func goBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addSong(_ sender: UIBarButtonItem) {
        var titleTextField = UITextField()
        var releaseDateTextField = UITextField()
        
        let alert = UIAlertController(title: "Enter new song", message: "", preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .default) { [self] (action) in
            let song = DataManager.shared.song(title: titleTextField.text ?? "", releaseDate: releaseDateTextField.text ?? "", singer: singer!)
            songs.append(song)
            tableView.reloadData()
            DataManager.shared.save()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: Formation"
            titleTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: February 6, 2016"
            releaseDateTextField = alertTextField
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
extension SongsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = songs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = song.title
        cell.detailTextLabel?.text = song.releaseDate
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editSongAction(indexPath: indexPath)
            completionHandler(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteSongAction(indexPath: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    private func editSongAction(indexPath: IndexPath) {
        let song = songs[indexPath.row]
        
        var titleTextField = UITextField()
        var releaseDateTextField = UITextField()
        
        let alert = UIAlertController(title: "Edit song", message: "", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            song.setValue(titleTextField.text ?? "", forKey: "title")
            song.setValue(releaseDateTextField.text ?? "", forKey: "releaseDate")
            DataManager.shared.save()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: Formation"
            alertTextField.text = song.title
            titleTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: February 6, 2016"
            alertTextField.text = song.releaseDate
            releaseDateTextField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteSongAction(indexPath: IndexPath) {
        let song = songs[indexPath.row]
        let areYouSureAlert = UIAlertController(title: "Are you sure you want to delete this song?", message: "", preferredStyle: .alert)
        let yesDeleteAction = UIAlertAction(title: "Yes", style: .destructive) { [self] (action) in
            DataManager.shared.deleteSong(song: song)
            songs.remove(at: indexPath.row)
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
