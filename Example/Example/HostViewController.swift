//
//  HostViewController.swift
// FlexBuilder
//
//  Created by Chu Thin on 16/07/2023.
//

import Foundation
import UIKit
import PinLayout
import FlexLayout

class HostViewController : UIViewController {
    let containerView : UIView
    init(_ view: UIView) {
        self.containerView = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.tag(UIViewController.BuilderContainerTag)
        view.backgroundColor(.white)
        view.addSubview(containerView)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
            containerView.pin.all(self.view.pin.safeArea)
            self.containerView.flex.layout()
    }
}
