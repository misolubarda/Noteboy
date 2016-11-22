//
//  NoteListViewController.swift
//  Noteboy
//
//  Created by Lubarda, Miso on 13/11/2016.
//  Copyright © 2016 Noteboy. All rights reserved.
//

import UIKit
import UserNotifications

class NoteListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func leftBarItemTapped(_ sender: UIBarButtonItem) {
    }

    @IBAction func rightBarItemTapped(_ sender: UIBarButtonItem) {
    }

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: nil, using: keyboardWillShow)
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: keyboardWillHide)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        setupNavigationBar(navigationBar: self.navigationController?.navigationBar)
        setupTable()
        /*
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert]) { (success: Bool, error: Error?) in
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Title", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "Body", arguments: nil)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: "Some", content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: { (error) in
                    print("error:\(error)")
                })
            }
        } else {

        }
         */
    }

    private func setupNavigationBar(navigationBar: UINavigationBar?) {
        guard let navigationBar = navigationBar else {
            return
        }
        let delimiter = UIView()
        delimiter.backgroundColor = AssetHelper.colorHeaderDelimiter
        navigationBar.addSubview(delimiter)
        delimiter.translatesAutoresizingMaskIntoConstraints = false
        delimiter.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        delimiter.leftAnchor.constraint(equalTo: navigationBar.leftAnchor).isActive = true
        delimiter.rightAnchor.constraint(equalTo: navigationBar.rightAnchor).isActive = true
        delimiter.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let leftItem = navigationBar.topItem?.leftBarButtonItem
        if let leftItemImage = leftItem?.image?.withRenderingMode(.alwaysOriginal) {
            leftItem?.image = leftItemImage
        }
    }

    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "NoteListCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(NoteListCell.self))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
    }

    func cell(cell: NoteListCell, enableEditing editing: Bool) {
        cell.isEditingEnabled = editing
        tableView.isScrollEnabled = !editing
        let currentOffset = tableView.contentOffset
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.setNavigationBarHidden(editing, animated: false)
            self.tableView.contentOffset = currentOffset
        })
        tableView.setContentOffset(CGPoint(x: 0, y: cell.frame.origin.y), animated: true)
    }
}

extension NoteListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NoteListCell.self), for: indexPath) as! NoteListCell
        var cellText = "A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel. A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel."
        if indexPath.row == 3 {
            cellText += "A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel. A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel."
            cellText += "A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel. A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel."
            cellText += "A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel. A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel."
            cellText += "A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel. A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel."
            cellText += "A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel. A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel."
            cellText += "A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel. A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel."
        }
        cell.configure(withTextDelegate: self, text: cellText)
        //cell.isCellExpanded = cell.isSelected
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedIndexPath = tableView.indexPathForSelectedRow, let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? NoteListCell {
            if selectedIndexPath == indexPath {
                self.cell(cell: selectedCell, enableEditing: true)
            } else if selectedCell.isEditingEnabled {
                self.cell(cell: selectedCell, enableEditing: false)
                return selectedIndexPath
            } else {
                selectedCell.isCellExpanded = false
                let cellBeingSelected = tableView.cellForRow(at: indexPath) as! NoteListCell
                cellBeingSelected.isCellExpanded = true
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        } else {
            let cellBeingSelected = tableView.cellForRow(at: indexPath) as! NoteListCell
            cellBeingSelected.isCellExpanded = true
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        return indexPath
    }
}

extension NoteListViewController: NoteListCellDelegate {
    func noteListCell(_ cell: NoteListCell, didEndEditingWithText: String) {
    }
}

//MARK: Keyboard notifications
extension NoteListViewController {
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset.bottom += keyboardSize.height
        }
    }

    func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset.bottom -= keyboardSize.height
        }
    }
}
