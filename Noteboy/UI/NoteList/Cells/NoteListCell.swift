//
//  NoteListCell.swift
//  Noteboy
//
//  Created by Lubarda, Miso on 14/11/2016.
//  Copyright © 2016 Noteboy. All rights reserved.
//

import UIKit
import UserNotifications

protocol NoteListCellDataSource: class {
    func widthForCell(cell: NoteListCell) -> CGFloat
}

protocol NoteListCellDelegate: class {
    func noteListCell(_ cell: NoteListCell, didEndEditingWithText: String)
}

class NoteListCell: UICollectionViewCell {

    private let backgroundHeightCompact: CGFloat = 50.0
    private let backgroundHeightExpanded: CGFloat = 200.0

    @IBOutlet private weak var textBackgroundView: UIView!
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    fileprivate weak var delegate: NoteListCellDelegate?
    fileprivate weak var dataSource: NoteListCellDataSource?
    var isEditingEnabled: Bool = false {
        didSet {
            if oldValue == isEditingEnabled {
                return
            }
            textView.isScrollEnabled = isEditingEnabled
            if isEditingEnabled {
                textView.becomeFirstResponder()
            } else {
                textView.resignFirstResponder()
            }
        }
    }

    @IBAction func deleteButtonAction(_ sender: UIButton) {
    }


    //MARK: - View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        textBackgroundView.layer.masksToBounds = true
        textBackgroundView.layer.cornerRadius = 6
        textBackgroundView.backgroundColor = AssetHelper.colorNoteBackgroundNormal
        headerBackgroundView.backgroundColor = AssetHelper.colorNoteHeader
        deleteButton.setTitleColor(AssetHelper.colorNoteBackgroundNormal, for: .normal)
        editButton.setTitleColor(AssetHelper.colorNoteBackgroundNormal, for: .normal)
        textView.textColor = AssetHelper.colorText
        textView.isUserInteractionEnabled = false
        textView.delegate = self
    }

    func configure(withTextDelegate delegate: NoteListCellDelegate, dataSource: NoteListCellDataSource, text: String) {
        self.delegate = delegate
        self.dataSource = dataSource
        textView.text = text
    }

    override var isSelected: Bool {
        didSet {
            UIView.transition(with: self, duration: 0.33, options: .curveLinear, animations: {
                if self.isSelected {
                    self.textBackgroundView.backgroundColor = AssetHelper.colorNoteBackgroundSelected
                } else {
                    self.textBackgroundView.backgroundColor = AssetHelper.colorNoteBackgroundNormal
                }
            }, completion: nil)
        }
    }

/*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 */
}

extension NoteListCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.noteListCell(self, didEndEditingWithText: textView.text)
    }
}
