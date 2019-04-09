//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by sunsetwan on 2019/4/9.
//  Copyright © 2019 sunsetwan. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    //Note the parentheses after the closure.
    //That assigns the result of calling the closure to your variable collisionBehavior the first time you reference the variable.
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        //animator.addBehavior(behavior)
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0
        //animator.addBehavior(behavior)
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2*CGFloat.pi).arc4random
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        push.action = { [unowned push, weak self] in
            //push.dynamicAnimator?.removeBehavior(push)
            self?.removeChildBehavior(push)
        }
        //animator.addBehavior(push)
        self.addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    // add the three behaviors above to cardBehavior, as childs
    // So 99.9% of the time, when you create a dynamic behavior, you're gonna override func init() with no arugument
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
