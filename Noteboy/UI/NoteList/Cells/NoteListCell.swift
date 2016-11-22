//
//  NoteListCell.swift
//  Noteboy
//
//  Created by Lubarda, Miso on 14/11/2016.
//  Copyright © 2016 Noteboy. All rights reserved.
//

import UIKit
import UserNotifications

protocol NoteListCellDelegate: class {
    func noteListCell(_ cell: NoteListCell, didEndEditingWithText: String)
}

class NoteListCell: UITableViewCell {

    private let backgroundHeightCompact: CGFloat = 50.0
    private let backgroundHeightExpanded: CGFloat = 200.0

    @IBOutlet private weak var textBackgroundView: UIView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private var backgroundHeight: NSLayoutConstraint!
    weak var delegate: NoteListCellDelegate?
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
    var isCellExpanded: Bool = false {
        didSet {
            self.backgroundHeight.constant = self.isCellExpanded ? self.backgroundHeightExpanded : self.backgroundHeightCompact
        }
    }

    //MARK: - View lifecycle
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

    /*
    override func prepareForReuse() {
        super.prepareForReuse()
        isCellExpanded = isSelected
    }
    */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            textBackgroundView.backgroundColor = AssetHelper.colorNoteBackgroundSelected
        } else {
            textBackgroundView.backgroundColor = AssetHelper.colorNoteBackgroundNormal
        }
    }
}

extension NoteListCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.noteListCell(self, didEndEditingWithText: textView.text)
    }
}
