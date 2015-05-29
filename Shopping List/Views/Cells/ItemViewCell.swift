//
//  ItemViewCell.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

@objc protocol ItemViewCellDelegate {
    func remove(cell: ItemViewCell)
    func done(cell: ItemViewCell)
}

class ItemViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var removeView: UIView!
    @IBOutlet weak var doneView: UIView!
    
    var delegate: ItemViewCellDelegate?
    var panGesture: UIPanGestureRecognizer?
    private var originalCenter: CGPoint?
    
    override func awakeFromNib() {
        panGesture = UIPanGestureRecognizer(target: self, action: "pan:")
        panGesture!.delegate = self
        self.addGestureRecognizer(panGesture!)
    }
    
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(panGesture) {
            if gestureRecognizer.numberOfTouches() > 0 {
                let translation = panGesture!.velocityInView(self)
                
                return fabs(translation.x) > fabs(translation.y)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Began {
            originalCenter = itemView.center
        }
        
        if gesture.state == .Changed {
            let translation = gesture.translationInView(self)
            itemView.center = CGPointMake(originalCenter!.x + translation.x, originalCenter!.y)
            
            if itemView.frame.minX > 0 {
                doneView.hidden = false
                removeView.hidden = true
            } else {
                doneView.hidden = true
                removeView.hidden = false
            }
        }
        
        if gesture.state == .Ended {
            if itemView.frame.minX > itemView.frame.size.width / 2.5 {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.itemView.frame.origin.x = self.itemView.frame.width
                }, completion: { (finished) -> Void in
                    self.delegate?.done(self)
                })
            } else if itemView.frame.maxX < itemView.frame.size.width / 2.5 {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.itemView.frame.origin.x = -(self.itemView.frame.width)
                }, completion: { (finished) -> Void in
                    self.delegate?.remove(self)
                })
            } else {
                UIView.animateWithDuration(0.4) {
                    self.itemView.frame.origin.x = 0
                }
            }
        }
    }
}
