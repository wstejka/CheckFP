//
//  UIView+Extension.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 14/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

extension UIView
{

    
    func addXib<T>(forType: T.Type) -> T where T: UIView
    {
        guard let view = Bundle.main.loadNibNamed(String(describing: forType), owner: self, options: nil)?.first as? T else {
            fatalError("Could not load view from nib file.")
        }

        _ = self.addSubview(view)
        let cornerRadius : CGFloat = 10.0
        self.layer.cornerRadius = cornerRadius
        view.layer.cornerRadius = cornerRadius

        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        return view
    }

}

// Originally from project: https://github.com/haaakon/SingleLineShakeAnimation, by Håkon Bogen on 24/04/15.
// Adjusted by me to Swift 3.*

public enum ShakeDirection: Int {
    case Horizontal
    case Vertical
    
    fileprivate func startPosition() -> ShakePosition {
        switch self {
        case .Horizontal:
            return ShakePosition.Left
        default:
            return ShakePosition.Top
        }
    }
}

private struct DefaultValues {
    static let numberOfTimes = 5
    static let totalDuration: Float = 0.5
}

extension UIView {
    
    /**
     Shake a view back and forth for the number of times given in the duration specified.
     If the total duration given is 1 second, and the number of shakes is 5, it will use 0.20 seconds per shake.
     After it's done shaking, the completion handler is called, if specified.
     
     - parameter direction:     The direction to shake (horizontal or vertical motion)
     - parameter numberOfTimes: The total number of times to shake back and forth, default value is 5
     - parameter totalDuration: Total duration to do the shakes, default is 0.5 seconds
     - parameter completion:    Optional completion closure
     */
    public func shake(direction: ShakeDirection, numberOfTimes: Int = DefaultValues.numberOfTimes, totalDuration: Float = DefaultValues.totalDuration, completion: (() -> Void)? = nil) -> UIView? {
        if UIAccessibilityIsVoiceOverRunning() {
            return self
        } else {
            let timePerShake = Double(totalDuration) / Double(numberOfTimes)
            shake(forTimes: numberOfTimes, position: direction.startPosition(), durationPerShake: timePerShake, completion: completion)
            return nil
        }
    }
    
    public func postAccessabilityNotification(text: String ) {
        var hasRead = false
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIAccessibilityAnnouncementDidFinish, object: nil, queue: nil) { (notification) -> Void in
            if hasRead == false {
                UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
                hasRead = true
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIAccessibilityAnnouncementDidFinish, object:nil)
            }
        }
//        // seems to be a bug with UIAccessability that does not allow to post a notification with text in the action when tapping a button
//        let time = dispatch_time(dispatch_time_t(DispatchTime.now()), Int64(0.01 * Double(NSEC_PER_SEC)))
//        dispatch_after(time, dispatch_get_main_queue()) {
//            
//        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, " ")
        }
    }
    
    func didFinishReadingAccessabilityLabel() {

        DispatchQueue.main.async(execute: {
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, "hello world")
        })
    }
    
    private func shake(forTimes: Int, position: ShakePosition, durationPerShake: TimeInterval, completion: (() -> Void)?) {
        UIView.animate(withDuration: durationPerShake, animations: { () -> Void in
            
            switch position.direction {
            case .Horizontal:
                self.layer.setAffineTransform( CGAffineTransform(translationX: 2 * position.value, y: 0))
                break
            case .Vertical:
                self.layer.setAffineTransform( CGAffineTransform(translationX: 0, y: 2 * position.value))
                break
            }
        }) { (complete) -> Void in
            if (forTimes == 0) {
                UIView.animate(withDuration: durationPerShake, animations: { () -> Void in
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) -> Void in
                    completion?()
                })
            } else {
                self.shake(forTimes: forTimes - 1, position: position.oppositePosition(), durationPerShake: durationPerShake, completion:completion)
            }
        }
    }
    
}

private struct ShakePosition  {
    
    let value: CGFloat
    let direction: ShakeDirection
    
    init(value: CGFloat, direction: ShakeDirection) {
        self.value = value
        self.direction = direction
    }
    
    func oppositePosition() -> ShakePosition {
        return ShakePosition(value: (self.value * -1), direction: direction)
    }
    
    static var Left: ShakePosition {
        return ShakePosition(value: 1, direction: .Horizontal)
    }
    
    static var Right: ShakePosition {
        return ShakePosition(value: -1, direction: .Horizontal)
    }
    
    static var Top: ShakePosition {
        return ShakePosition(value: 1, direction: .Vertical)
    }
    
    static var Bottom: ShakePosition {
        return ShakePosition(value: -1, direction: .Vertical)
    }
    
}

