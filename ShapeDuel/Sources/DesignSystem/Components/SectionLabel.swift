//
//  SectionLabel.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 26.09.2026.
//

import UIKit

/// Uppercase label above a block: «Сложность», «Ваша фигура», «Оформление»
final class SectionLabel: UILabel {

    // MARK: - Properties

    override var text: String? {
        get { attributedText?.string }
        set { updateText(newValue) }
    }

    // MARK: - Initial

    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfLines = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func updateText(_ text: String?) {
        guard let text else {
            attributedText = nil
            return
        }
        let font = Typography.sectionLabel.font()
        attributedText = NSAttributedString(
            string: text.localizedUppercase,
            attributes: [
                .font: font,
                .kern: Typography.sectionLabel.tracking * font.pointSize,
                .foregroundColor: UIColor.secondaryText
            ]
        )
    }
}
