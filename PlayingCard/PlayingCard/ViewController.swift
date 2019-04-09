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
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
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
            //            cardBehavior.addItem(cardView)
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
                                  duration: 0.6,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                },
                                  completion: { finished in
                                    // But do we actually have a memory cycle here?
                                    // No, because this closure does capture self, self doesn't point to this closure in any way.
                                    // It's not part of any var. It's not any part of a dictionary or an array or anything that self has.
                                    // It's a closure we're giving off to the animation system.
                                    // So only the animation system has a pointer to it.
                                    // There is no memory cycle.
                                    if self.faceUpCardViews.count == 2 {
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

