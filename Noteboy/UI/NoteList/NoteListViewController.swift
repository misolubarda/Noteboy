//
//  NoteListViewController.swift
//  Noteboy
//
//  Created by Lubarda, Miso on 13/11/2016.
//  Copyright © 2016 Noteboy. All rights reserved.
//

import UIKit

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

    private func setupUI() {
        setupNavigationBar(navigationBar: self.navigationController?.navigationBar)
        setupTable()
    }

    private func setupNavigationBar(navigationBar: UINavigationBar?) {
        guard let navigationBar = navigationBar else {
            return
        }
        let delimiter = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.width, height: 1)))
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
        tableView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
    }
}

extension NoteListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NoteListCell.self), for: indexPath) as! NoteListCell
        let cellText = "A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel. A friend is someone who gives you total freedom to be yourself - and especially to feel, or not feel."
        cell.configure(withTextDelegate: self, text: cellText)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
            self.tableView(tableView, didDeselectRowAt: selectedIndexPath)
            return nil
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NoteListCell
        cell.isEditingEnabled(true)
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToNearestSelectedRow(at: .none, animated: true)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NoteListCell
        cell.isEditingEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension NoteListViewController: NoteListCellDelegate {
    func noteListCell(_ cell: NoteListCell, didEndEditingWithText: String) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
