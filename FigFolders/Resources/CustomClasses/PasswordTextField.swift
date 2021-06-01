//
//  PasswordTextField.swift
//  FigFolders
//
//  Created by Lourdes on 5/31/21.
//

import UIKit

class PasswordTextField: UITextField {
    let rightButtonWidth: CGFloat = 45
    let eyeImageName = "eye"
    let eyeSlashedImageName = "eye.slash"
    let imageTintColor = UIColor.black
    
    var rightButton: UIButton?
    
    // To Not clear text when secure entry is toggled
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
    
    // Give Padding
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: rightButtonWidth))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    // Setup View and Add Peek Button To The Right
    func setupView() {
        let rightButtonFrame = CGRect(x: self.frame.maxX - rightButtonWidth, y: 0, width: rightButtonWidth, height: self.frame.height)
        let showPasswordButton = UIButton(frame: rightButtonFrame)
        showPasswordButton.setImage(UIImage(systemName: eyeImageName), for: .normal)
        showPasswordButton.addTarget(self, action: #selector(onTapShowPasswordButton), for: .touchUpInside)
        showPasswordButton.tintColor = imageTintColor
        self.rightButton = showPasswordButton
        showPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        self.rightViewMode = .always
        self.rightView = showPasswordButton
    }
    
    // Peek Function
    @objc private func onTapShowPasswordButton() {
        self.isSecureTextEntry.toggle()
        rightButton?.setImage(UIImage(systemName: isSecureTextEntry ? eyeImageName: eyeSlashedImageName), for: .normal)
    }
}
