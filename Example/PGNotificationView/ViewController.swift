//
//  ViewController.swift
//  PGNotificationView
//
//  Created by ipagong.dev on 05/31/2017.
//  Copyright (c) 2017 ipagong.dev All rights reserved.
//

import UIKit
import PGNotificationView

class ViewController: UIViewController {

    @IBAction func onClickFirst(_ button: UIButton) {
        self.hideAll()
        NotificationView.create(NotiView(button.titleLabel!.text!))?.setupDuration(present: 0.3, dismiss: 0.3, expose: 5)
            .show()
    }
    
    @IBAction func onClickSecond(_ button: UIButton) {
        self.hideAll()
        NotificationView.create(NotiView(button.titleLabel!.text!))?.setupDuration(present: 0.3, dismiss: 0.3, expose: 3)
            .whenCompletion { completed in
                print("hide completion.")
            }
            .show()
    }
    
    @IBAction func onClickThird(_ button: UIButton) {
        self.hideAll()
        NotificationView.create(GreenNotiView(button.titleLabel!.text!))?
            .whenTouch { view in
                print("third notification touched.")
            }
            .show()
    }
    
    @IBAction func onClickLast(_ button: UIButton) {
        self.hideAll()
        NotificationView.create(GreenNotiView(button.titleLabel!.text!))?.show()
    }
    
    public func hideAll() {
        [GreenNotiView.self, NotiView.self].forEach { NotificationView.findAll($0)?.forEach({ view in view.hide(animated: true, completed: false) }) }
    }
}

class NotiView: UILabel, NotificationViewProtocol {
    func didHide(completed: Bool) {
        print("notiview hide." + (completed ? "finished" : "no finished"))
    }

    func didShow() {
        print("notiview show.")
    }

    public init(_ message:String) {
        super.init(frame: .zero)
        
        self.backgroundColor = .yellow
        self.font = UIFont.systemFont(ofSize: 15)
        self.textAlignment = .center
        self.numberOfLines = 0
        self.text = message
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        var size:CGSize {
            guard let text = self.text else { return .zero }
            
            return (text as NSString).boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: .infinity),
                                                   options: [.usesLineFragmentOrigin],
                                                   attributes: [.font : UIFont.systemFont(ofSize: 15)],
                                                   context: nil).size
        }
        
        return CGSize(width: size.width, height: size.height + 20)
    }
}

class GreenNotiView : NotiView {
    override init(_ message: String) {
        super.init(message)
        self.backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

