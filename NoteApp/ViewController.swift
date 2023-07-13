//
//  ViewController.swift
//  NoteApp
//
//  Created by Trung on 10/07/2023.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    var models: [(title: String, note: String)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotesFromUserDefaults()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        title = "Notes"
        
    }
    public func loadNotesFromUserDefaults() {
        guard let savedNotes = UserDefaults.standard.array(forKey: "savedNotes") as? [[String: String]] else {
            table.isHidden = true
            return
        }
        models = savedNotes.map { (title: $0["title"] ?? "", note: $0["note"] ?? "") }
        table.reloadData()
    }
    @IBAction func didTapNewNote() {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else {
            return
        }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { noteTitle, note in
            self.navigationController?.popViewController(animated: true)
            self.models.append((title: noteTitle,note: note))
            self.label.isHidden = true
            self.table.isHidden = false
            self.table.reloadData()
            self.saveNotesToUserDefaults()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    private func saveNotesToUserDefaults() {
        let notes = models.map { ["title": $0.title, "note": $0.note] }
        UserDefaults.standard.set(notes, forKey: "savedNotes")
    }
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        cell.detailTextLabel?.text = models[indexPath.row].note
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "note") as? NoteViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Note"
        vc.noteTitle = model.title
        vc.note = model.note
        navigationController?.pushViewController(vc, animated: true)
    }
}

