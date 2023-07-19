//
//  UIImage+Extensions.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit

extension UIImage {

    /**
     Initializes and returns the image object of the specified color and size.
     */
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }

}
