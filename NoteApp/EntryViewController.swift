//
//  EntryViewController.swift
//  NoteApp
//
//  Created by Trung on 10/07/2023.
//

import Foundation
import UIKit


class EntryViewController: UIViewController {
    
    @IBOutlet var titleField : UITextField!
    @IBOutlet var noteField: UITextView!
    
    public var completion: ((String, String) -> Void)?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        titleField.resignFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc func didTapSave() {
        if let text = titleField.text, !text.isEmpty, !noteField.text.isEmpty {
            let newNote = Note(title: text, content: noteField.text)
            saveNoteToUserDefaults(newNote)
            completion?(text, noteField.text)
        }
    }
    private func saveNoteToUserDefaults(_ note: Note) {
        var savedNotes = UserDefaults.standard.array(forKey: "savedNotes") as? [[String: String]] ?? [[String: String]]()
        let noteDictionary = ["title": note.title, "content": note.content]
        savedNotes.append(noteDictionary)
        UserDefaults.standard.set(savedNotes, forKey: "savedNotes")
    }
}
