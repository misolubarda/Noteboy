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

    fileprivate static let cellHeightNormal = CGFloat(100.0)
    fileprivate static let cellHeightExpanded = CGFloat(200.0)

    @IBOutlet weak var defaultCollectionView: UICollectionView!
    var notes = [Note]()

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
        for _ in 1...10 {
            var note = Note()
            note.text = "A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel. A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel."
            notes.append(note)
        }

        var note = notes[3]
        note.text += note.text
        note.text += note.text
        note.text += note.text
        note.text += note.text
        note.text += note.text
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
        defaultCollectionView.dataSource = self
        defaultCollectionView.delegate = self
        defaultCollectionView.register(UINib(nibName: "NoteListCell", bundle: nil), forCellWithReuseIdentifier: NSStringFromClass(NoteListCell.self))
        defaultCollectionView.contentInset = .init(top: 15, left: 0, bottom: 15, right: 0)
    }


    func cell(cell: NoteListCell, enableEditing editing: Bool) {
        cell.isEditingEnabled = editing
        defaultCollectionView.isScrollEnabled = !editing
        let currentOffset = defaultCollectionView.contentOffset
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.setNavigationBarHidden(editing, animated: false)
            self.defaultCollectionView.contentOffset = currentOffset
        })
        defaultCollectionView.setContentOffset(CGPoint(x: 0, y: cell.frame.origin.y), animated: true)
    }

}

extension NoteListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let note = notes[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(NoteListCell.self), for: indexPath) as! NoteListCell
        cell.configure(withTextDelegate: self, dataSource: self, text: note.text)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems, selectedIndexPaths.contains(indexPath) {
            let cell = collectionView.cellForItem(at: indexPath) as! NoteListCell
            cell.isEditingEnabled = true
            //.scrollToNearestSelectedRow(at: .none, animated: true)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            return false
        }
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView(collectionView, makeCellExpanded: true, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.collectionView(collectionView, makeCellExpanded: false, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems, selectedIndexPaths.contains(indexPath) {
            let cell = collectionView.cellForItem(at: indexPath) as! NoteListCell
            if cell.isEditingEnabled {
                return CGSize(width: collectionView.frame.width, height: 300)
            } else {
                return CGSize(width: collectionView.frame.width, height: type(of: self).cellHeightExpanded)
            }
        }
        return CGSize(width: collectionView.frame.width, height: type(of: self).cellHeightNormal)
    }

    func collectionView(_ collectionView: UICollectionView, makeCellExpanded expanded:Bool, indexPath: IndexPath) {
        collectionView.performBatchUpdates({
            guard let cell = collectionView.cellForItem(at: indexPath) else {
                return
            }
            self.makeCell(cell, expanded: expanded)
        }, completion: nil)
    }

    func makeCell(_ cell: UICollectionViewCell, expanded: Bool) {
        UIView.transition(with: cell, duration: 0.3, options: .curveEaseInOut, animations: {
            var frame = cell.frame
            let height = expanded ? type(of: self).cellHeightExpanded : type(of: self).cellHeightNormal
            frame.size = CGSize(width: frame.width, height: height)
            cell.frame = frame
            cell.layoutIfNeeded()
        }, completion: nil)
    }
}

extension NoteListViewController: NoteListCellDelegate {

    func noteListCelldidTapOnSave(_ cell: NoteListCell) {
        defaultCollectionView.performBatchUpdates({
            cell.isEditingEnabled = false
            self.makeCell(cell, expanded: true)
        }, completion: nil)
    }

    func noteListCell(_ cell: NoteListCell, didEndEditingWithText: String) {
    }
}

extension NoteListViewController: NoteListCellDataSource {
    func widthForCell(cell: NoteListCell) -> CGFloat {
        return self.defaultCollectionView.contentSize.width - 20
    }
}

//MARK: Keyboard notifications
extension NoteListViewController {
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            defaultCollectionView.performBatchUpdates({
                guard let selectedIndexPath = self.defaultCollectionView.indexPathsForSelectedItems?.first, let cell = self.defaultCollectionView.cellForItem(at: selectedIndexPath) else {
                    return
                }
                self.defaultCollectionView.contentInset.bottom += keyboardSize.height

                UIView.transition(with: cell, duration: 0.3, options: .curveEaseInOut, animations: {
                    var frame = cell.frame
                    let height = self.defaultCollectionView.frame.height - keyboardSize.height
                    frame.size = CGSize(width: frame.width, height: height)
                    cell.frame = frame
                    cell.layoutIfNeeded()
                }, completion: nil)
            }, completion: nil)

        }
    }

    func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            defaultCollectionView.contentInset.bottom -= keyboardSize.height
        }
    }
}
