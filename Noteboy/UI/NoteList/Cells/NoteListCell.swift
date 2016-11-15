//
//  NoteListCell.swift
//  Noteboy
//
//  Created by Lubarda, Miso on 14/11/2016.
//  Copyright © 2016 Noteboy. All rights reserved.
//

import UIKit

protocol NoteListCellDelegate: class {
    func noteListCell(_ cell: NoteListCell, didEndEditingWithText: String)
}

class NoteListCell: UITableViewCell {

    @IBOutlet private weak var textBackgroundView: UIView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private var backgroundHeight: NSLayoutConstraint!
    weak var delegate: NoteListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        textBackgroundView.layer.masksToBounds = true
        textBackgroundView.layer.cornerRadius = 6
        textBackgroundView.backgroundColor = AssetHelper.colorNoteBackgroundNormal
        textView.textColor = AssetHelper.colorText
        textView.isUserInteractionEnabled = false
        textView.delegate = self
    }

    func configure(withTextDelegate delegate: NoteListCellDelegate, text: String) {
        self.delegate = delegate
        textView.text = text
    }

    func isEditingEnabled(_ enabled: Bool) {
        textView.isScrollEnabled = enabled
        if enabled {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            textBackgroundView.backgroundColor = AssetHelper.colorNoteBackgroundSelected
            backgroundHeight.isActive = false
        } else {
            textBackgroundView.backgroundColor = AssetHelper.colorNoteBackgroundNormal
            backgroundHeight.isActive = true
        }
    }
}

extension NoteListCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.noteListCell(self, didEndEditingWithText: textView.text)
    }
}
