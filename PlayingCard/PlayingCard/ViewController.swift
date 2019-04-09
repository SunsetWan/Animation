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
        for _ in 1...((cardViews.count+1)/2) {
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


    
    
    
    
    
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView {
                chosenCardView.isFaceUp = !chosenCardView.isFaceUp
            }
        default:
            break
        }
    }
    
}

