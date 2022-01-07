//
//  TextViewWithPlaceholder.swift
//  FigFolders
//
//  Created by Lourdes on 7/27/21.
//

import UIKit

class TextViewWithPlaceholder: UITextView {

    private var placeholderTextView: UITextView = UITextView()

    var placeholder: String? {
        didSet {
            placeholderTextView.text = placeholder
        }
    }

    override var text: String! {
        didSet {
            placeholderTextView.isHidden = text.isEmpty == false
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        applyCommonTextViewAttributes(to: self)
        configureMainTextView()
        addPlaceholderTextView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }

    func addPlaceholderTextView() {
        applyCommonTextViewAttributes(to: placeholderTextView)
        configurePlaceholderTextView()
        insertSubview(placeholderTextView, at: 0)
    }

    private func applyCommonTextViewAttributes(to textView: UITextView) {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 10,
                                                   left: 10,
                                                   bottom: 10,
                                                   right: 10)
    }

    private func configureMainTextView() {
        // Do any configuration of the actual text view here
    }

    private func configurePlaceholderTextView() {
        placeholderTextView.text = placeholder
        placeholderTextView.font = font
        placeholderTextView.textColor = UIColor.lightGray
        placeholderTextView.frame = bounds
        placeholderTextView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderTextView.frame = bounds
    }

    @objc func textDidChange() {
        placeholderTextView.isHidden = !text.isEmpty
    }

}
