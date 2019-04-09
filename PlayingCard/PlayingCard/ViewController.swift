//
//  ViewController.swift
//  PlayingCard
//
//  Created by sunsetwan on 2019/4/9.
//  Copyright © 2019 sunsetwan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var deck = PlayingCardDeck()
    
    //An object that provides physics-related capabilities and animations for its dynamic items,
    //and provides the context for those animations.
    //To use dynamics, configure one or more dynamic behaviors—including providing each with a set of dynamic items—and,
    //then add those behaviors to a dynamic animator.
    lazy var animator = UIDynamicAnimator(referenceView: view)

    //Note the parentheses after the closure.
    //That assigns the result of calling the closure to your variable collisionBehavior the first time you reference the variable.
   
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
        faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
        faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
   
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)
            //collisionBehavior.addItem(cardView)
            //itemBehavior.addItem(cardView)
        }
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter { $0.isFaceUp && !$0.isHidden }
    }
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView {
                UIView.transition(with: chosenCardView,
                                  duration: 0.8,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                },
                                  completion: { finished in
                                    if self.faceUpCardViewsMatch {
                                        // The animator operates on animatable properties of views, such as the frame, center, alpha, and transform properties, creating the needed animations from the blocks you provide.
                                        UIViewPropertyAnimator.runningPropertyAnimator(
                                            withDuration: 0.6,
                                            delay: 0,
                                            options: [],
                                            animations: {
                                               self.faceUpCardViews.forEach {
                                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                }
                                            },
                                            completion: { position in
                                                UIViewPropertyAnimator.runningPropertyAnimator(
                                                    withDuration: 0.6,
                                                    delay: 0,
                                                    options: [],
                                                    animations: {
                                                        self.faceUpCardViews.forEach {
                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                            $0.alpha = 0
                                                        }
                                                },
                                                    // Do some cleanup,
                                                    // We want to remove these cards which already matched.
                                                    // Because they no longer can be involved in the matches.
                                                     completion: { position in
                                                        self.faceUpCardViews.forEach {
                                                            $0.isHidden = true
                                                            $0.alpha = 1
                                                            // set faceUpCardView's transform back to "identity", this means "reset".
                                                            $0.transform = .identity
                                                        }
                                                        
                                                }
                                                
                                                
                                                )
                                                
                                            }
                                        )
                                    }
                                    
                                    
                                    // But do we actually have a memory cycle here?
                                    // No, because this closure does capture self, self doesn't point to this closure in any way.
                                    // It's not part of any var. It's not any part of a dictionary or an array or anything that self has.
                                    // It's a closure we're giving off to the animation system.
                                    // So only the animation system has a pointer to it.
                                    // There is no memory cycle.
                                   else if self.faceUpCardViews.count == 2 {
                                        self.faceUpCardViews.forEach { cardView in
                                            UIView.transition(with: cardView,
                                                              duration: 0.6,
                                                              options: [.transitionFlipFromLeft],
                                                              animations: {
                                                                cardView.isFaceUp = false
                                            }
//                                                              completion: { finished in
//
//                                            }
                                            )
                                        }
                                    }
//                                    UIView.transition(with: chosenCardView,
//                                                      duration: 0.6,
//                                                      options: [.transitionFlipFromLeft],
//                                                      animations: {
//                                                        chosenCardView.isFaceUp = !chosenCardView.isFaceUp
//                                    },
//                                                      completion: { finished in
//
//                                    }
//                                    )
                    }
                )
                
            }
        default:
            break
        }
    }
    
}

