//
//  ItemViewCell.swift
//  Shopping List
//
//  Created by Diego Haz on 5/28/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import UIKit

@objc protocol ItemViewCellDelegate {
    func removeItem(cell: ItemViewCell)
    func doneItem(cell: ItemViewCell)
}

class ItemViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var removeView: UIView?
    @IBOutlet weak var doneView: UIView?
    @IBOutlet weak var horizontal: NSLayoutConstraint!
    @IBOutlet weak var largePenis: NSLayoutConstraint!
    
    var delegate: ItemViewCellDelegate?
    var panGesture: UIPanGestureRecognizer?
    private var originalHorizontal: CGFloat?
    
    override func awakeFromNib() {
        panGesture = UIPanGestureRecognizer(target: self, action: "pan:")
        panGesture!.delegate = self

        self.addGestureRecognizer(panGesture!)
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if delegate == nil {
            return false
        }
        
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
            originalHorizontal = horizontal.constant
        }
        
        if gesture.state == .Changed {
            let translation = gesture.translationInView(self)
            horizontal.constant = translation.x + originalHorizontal!
            
            if horizontal.constant > originalHorizontal! {
                largePenis.constant = 0
            } else {
                largePenis.constant = -translation.x
            }
            
            self.layoutIfNeeded()
        }
        
        if gesture.state == .Ended {
            if horizontal.constant - originalHorizontal! > self.frame.width / 3 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.horizontal.constant = self.frame.width
                    self.largePenis.constant = 0
                    self.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    self.delegate?.doneItem(self)
                    self.reset()
                })
            } else if largePenis.constant > self.frame.width / 3 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.horizontal.constant = self.originalHorizontal!
                    self.largePenis.constant = self.itemView.frame.width
                    self.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    self.delegate?.removeItem(self)
                    self.reset()
                })
            } else {
                UIView.animateWithDuration(0.4) {
                    self.horizontal.constant = self.originalHorizontal!
                    self.largePenis.constant = 0
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func reset() {
        self.horizontal.constant = originalHorizontal!
        self.largePenis.constant = 0
    }
}
