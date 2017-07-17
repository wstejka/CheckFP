//
//  WSUtils.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 14/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation



// Swift 3
func synchronized<T>(_ lock: AnyObject, _ body: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try body()
}

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}


// Custom UITextField class with "0.00" format
class WSUITextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSettings()
        registerForNotifications()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSettings()
        registerForNotifications()
    }
    
    private var valueBeforeChange : String = ""
    let defaultValue : String = "0.00"
    
    private func initialSettings() {
        self.keyboardType = UIKeyboardType.decimalPad
        self.textAlignment = NSTextAlignment.right
        self.text = defaultValue
        self.placeholder = defaultValue
        valueBeforeChange = defaultValue
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange),
                                               name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing),
                                               name: NSNotification.Name(rawValue: "UITextFieldTextDidEndEditingNotification"), object: self)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func textDidChange() {
        log.info("textDidChange = \(valueBeforeChange)")
        
        if text == "" {
            valueBeforeChange = ""
            return
        }
        if text == "." {
            text = "0."
        }
        
        guard let _ = Float(text!) else { return text = valueBeforeChange }
        valueBeforeChange = text!
    }
    
    @objc private func textDidEndEditing() {
        log.info("textDidEndEditing = \(valueBeforeChange)")
        
        guard let _ = Float(text!) else {
            text = defaultValue
            valueBeforeChange = defaultValue
            return
        }
        text = String(format:"%.2f", Float(text!)!)
    }
    
    public func getValue() -> String {
        
        guard let _ = Float(text!) else { return defaultValue }
        return text!
    }
}


