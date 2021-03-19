//
//  NotificationView.swift
//  Pods
//
//  Created by ipagong on 2017. 5. 31..
//
//

import Foundation

public protocol NotificationViewProtocol {
    func didShow()
    func didHide(completed: Bool)
}

open class NotificationView: UIWindow {
    
    public typealias TouchClosure = (UIView?) -> ()
    public typealias CompletedClosure = (Bool) -> ()
    
    public var delayDuration: TimeInterval = 0
    public var exposeDuration: TimeInterval = 2
    
    public var presentDuration: TimeInterval = 0.3
    public var dismissDuration: TimeInterval = 0.3
    
    fileprivate var canDisplay: Bool = true
    
    public var touchClosure: TouchClosure?
    public var completionClosure: CompletedClosure?
    
    public var contentView: UIView?
    
    public static var queue = NotificationViewQueue()
    
    lazy public var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    
    deinit {
        debugPrint("NotificationView deinit.")
    }
    
    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        guard let _ = self.contentView else  { return }
        
        self.hide(animated:false)
        
        self.touchClosure?(self.contentView!)
    }
}

//class methods
extension NotificationView {
    
    public class func create(_ contentView: UIView?) -> NotificationView? {
        guard let view = contentView else { return nil }
        
        let notiView = NotificationView(frame: .zero)
        notiView.contentView = view
        
        notiView.translatesAutoresizingMaskIntoConstraints = false
        notiView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: notiView.leftAnchor),
            view.rightAnchor.constraint(equalTo: notiView.rightAnchor),
            view.topAnchor.constraint(equalTo: notiView.topAnchor),
            view.bottomAnchor.constraint(equalTo: notiView.bottomAnchor),
        ])
        
        notiView.isHidden = true
        notiView.windowLevel = .statusBar

        view.setNeedsLayout()
        view.layoutIfNeeded()

        let size = view.intrinsicContentSize

        notiView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: size.height + Self.windowSafeAreaTop)
        view.frame = notiView.bounds
        
        return notiView
    }
    
    public class func find(_ contentView: UIView.Type) -> NotificationView? {
        return queue.find(contentView)
    }
    
    public class func findAll(_ contentView: UIView.Type) -> [NotificationView]? {
        return queue.findAll(contentView)
    }

}

// public show/hide/setup methods.
extension NotificationView {
    
    public func show() {
        guard let _ = self.contentView else { return }
        guard self.canDisplay == true  else { return }
        guard self.isHidden == true    else { return }
        
        self.makeKeyAndVisible()
        self.isHidden = false
        
        self.transform = .init(translationX: 0, y: -self.bounds.height)
        
        UIView.animate(withDuration: self.presentDuration,
                       delay: self.delayDuration,
                       options: [],
                       animations: { [weak self] in
                        guard let self = self else { return }
                        self.transform = .identity
                        if let sender = self.contentView as? NotificationViewProtocol { sender.didShow() }
        },
                       completion: { [weak self]_ in
                        guard let self = self else { return }
                        self.transform = .identity
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.exposeDuration, execute: { self.hide() })
        })
        NotificationView.queue.add(self)
    }
    
    public func hide(animated: Bool = true, completed: Bool = true) {
        self.canDisplay = false
        guard self.isHidden == false else { return }
        
        UIView.animate(withDuration: animated ? self.dismissDuration : 0,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        self.transform = .init(translationX: 0, y: -self.bounds.height)
                        if let sender = self.contentView as? NotificationViewProtocol { sender.didHide(completed: completed) }
        },
                       completion: { [weak self] _ in
                        guard let self = self else { return }
                        self.isHidden = true
                        self.transform = .identity
                        self.completionClosure?(completed)
                        NotificationView.queue.remove(self)
        })
    }
    
    @discardableResult
    public func whenTouch(_ touchClosure: @escaping TouchClosure) -> NotificationView {
        guard let _ = self.contentView else  { return self }
        
        self.gestureRecognizers?.forEach { self.removeGestureRecognizer($0) }
        self.addGestureRecognizer(self.tapGesture)
        self.touchClosure = touchClosure
        
        return self
    }
    
    @discardableResult
    public func whenCompletion(_ completionClosure: @escaping CompletedClosure) -> NotificationView {
        guard let _ = self.contentView else  { return self }
        
        self.completionClosure = completionClosure
        
        return self
    }
    
    @discardableResult
    public func setupDuration(present: TimeInterval = TimeInterval.infinity,
                              dismiss: TimeInterval = TimeInterval.infinity,
                              delay: TimeInterval   = TimeInterval.infinity,
                              expose: TimeInterval  = TimeInterval.infinity) -> NotificationView {
        guard let _ = self.contentView else  { return self }
        
        if (present != TimeInterval.infinity) { self.presentDuration = present }
        if (dismiss != TimeInterval.infinity) { self.dismissDuration = dismiss }
        if (delay   != TimeInterval.infinity) { self.delayDuration   = delay   }
        if (expose  != TimeInterval.infinity) { self.exposeDuration  = expose  }
        
        return self
    }
}



extension NotificationView {
    static var windowSafeAreaTop: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        } else {
            return 0
        }
    }
}
