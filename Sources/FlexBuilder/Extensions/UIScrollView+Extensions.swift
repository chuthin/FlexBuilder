//
//  UIScrollView+Extensions.swift
//  FlexBuilder
//
//  Created by Chu Thin on 16/07/2023.
//

import UIKit
public extension UIScrollView {
    var currentPage: Int {
      return Int((self.contentOffset.x + (0.5 * self.frame.size.width))/self.frame.width)
    }
    
    func scrollTo(horizontalPage: Int? = 0, verticalPage: Int? = 0, animated: Bool? = true) {
        if horizontalPage != nil || verticalPage != nil {
            var frame: CGRect = self.frame
            frame.origin.x = frame.size.width * CGFloat(horizontalPage ?? 0)
            frame.origin.y = frame.size.width * CGFloat(verticalPage ?? 0)
            self.scrollRectToVisible(frame, animated: animated ?? true)
        }
    }
}


