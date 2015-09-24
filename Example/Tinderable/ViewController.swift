//
//  ViewController.swift
//
//  Created by Orkhan Alizade on 4/27/15.
//  Copyright (c) 2015 Orkhan Alizade. All rights reserved.
//

import UIKit
import performSelector_swift
import UIColor_FlatColors
import Cartography
import ReactiveUI

class ViewController: UIViewController {
    
    var swipeableView: TinderableView!
    
        var colors = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
        var colorIndex = 0
    var loadCardsFromXib = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeableView.loadViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        view.clipsToBounds = true
        
        swipeableView = TinderableView()
        view.addSubview(swipeableView)
        
        swipeableView.didStart = {view, location in
            print("Did start swiping view at location: \(location)")
        }
        swipeableView.swiping = {view, location, translation in
            print("Swiping at view location: \(location) translation: \(translation)")
        }
        swipeableView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        swipeableView.didSwipe = {view, direction, vector in
            print("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        swipeableView.didCancel = {view in
            print("Did cancel swiping view")
        }
        
        swipeableView.nextView = {
            if self.colorIndex < self.colors.count {
            let cardView = CardView(frame: self.swipeableView.bounds)
            cardView.backgroundColor = self.colorForName(self.colors[self.colorIndex])
            self.colorIndex++
            
            if self.loadCardsFromXib {
                let contentView = NSBundle.mainBundle().loadNibNamed("CardContentView", owner: self, options: nil).first! as! UIView
                
                contentView.translatesAutoresizingMaskIntoConstraints = false
                contentView.backgroundColor = cardView.backgroundColor
                
                cardView.addSubview(contentView)
                
                constrain(contentView, cardView) { view1, view2 in
                    view1.left == view2.left
                    view1.top == view2.top
                    view1.width == cardView.bounds.width
                    view1.height == cardView.bounds.height
                }
            }
            return cardView
            }
            return nil
        }
        
        constrain(swipeableView, view) { view1, view2 in
            view1.left == view2.left+50
            view1.right == view2.right-50
            view1.top == view2.top + 120
            view1.bottom == view2.bottom - 100
        }
    }
    
    // MARK: ()
    func colorForName(name: String) -> UIColor {
        let sanitizedName = name.stringByReplacingOccurrencesOfString(" ", withString: "")
        let selector = "flat\(sanitizedName)Color"
        return UIColor.swift_performSelector(Selector(selector), withObject: nil) as! UIColor
    }
}

extension UIImageView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}

