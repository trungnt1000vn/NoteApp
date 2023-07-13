//
//  NoteViewController.swift
//  NoteApp
//
//  Created by Trung on 10/07/2023.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var noteLabel: UITextField!
    
    
    public var noteTitle: String = ""
    public var note: String = ""
    private var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = noteTitle
        noteLabel.text = note
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(didTapEdit))
    }
    
    @objc func didTapEdit() {
        if isEdit == false {
            isEdit = true
            titleLabel.isUserInteractionEnabled = true
            noteLabel.isUserInteractionEnabled = true
            self.navigationItem.rightBarButtonItem?.title = "Save"
        } else {
            isEdit = false
            titleLabel.isUserInteractionEnabled = false
            noteLabel.isUserInteractionEnabled = false
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            
            // Lưu lại ghi chú đã chỉnh sửa
            if let newNote = noteLabel.text {
                note = newNote
                saveNoteToUserDefaults()
                updateNote()
            }
        }
    }
    
    private func updateNote() {
        // Cập nhật ghi chú trong danh sách gốc
        guard let viewControllers = navigationController?.viewControllers else {
            return
        }
        
        for viewController in viewControllers {
            if let viewController = viewController as? ViewController {
                if let index = viewController.models.firstIndex(where: { $0.title == noteTitle }) {
                    viewController.models[index].note = note
                    viewController.table.reloadData()
                    break
                }
            }
        }
    }
    
    private func saveNoteToUserDefaults() {
        var savedNotes = [[String: String]]()
        if let notes = UserDefaults.standard.array(forKey: "savedNotes") as? [[String: String]] {
            savedNotes = notes
        }
        
        if let index = savedNotes.firstIndex(where: { $0["title"] == noteTitle }) {
            savedNotes[index]["note"] = note
        } else {
            savedNotes.append(["title": noteTitle, "note": note])
        }
        
        UserDefaults.standard.set(savedNotes, forKey: "savedNotes")
        UserDefaults.standard.synchronize()
    }
}
