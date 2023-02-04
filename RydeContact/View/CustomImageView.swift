//
//  CustomImageView.swift
//  RydeContact
//
//  Created by LIN SHI ZHENG on 2/2/23.
//

import UIKit

class CustomImageView: UIImageView {
    public func maskCircle(anyImage: UIImage?) {
        if let image = anyImage {
            self.contentMode = UIView.ContentMode.scaleAspectFill
            self.layer.cornerRadius = self.frame.height / 2
            self.layer.masksToBounds = false
            self.clipsToBounds = true
            
            self.image = image
        }
    }
    
    public func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
