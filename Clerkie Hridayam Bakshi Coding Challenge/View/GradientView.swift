//
//  GradientView.swift
//  Clerkie Hridayam Bakshi Coding Challenge
//
//  Created by hridayam bakshi on 1/16/19.
//  Copyright © 2019 hridayam bakshi. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIScrollView {
    
    @IBInspectable var FirstColor: UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var SecondColor: UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
        layer.locations = [0.5]
    }
}
