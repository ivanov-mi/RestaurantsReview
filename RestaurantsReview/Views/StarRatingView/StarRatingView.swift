//
//  StarRatingView.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/13/25.
//

import UIKit

class StarRatingView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    private var imageViews: [UIImageView] = []
    
    var rating: Double = 0 {
        didSet {
            updateStars()
        }
    }
    
    var maxRating = 5
    var starSize: CGFloat = 32 {
        didSet {
            updateStarSizes()
        }
    }

    let filledStar = UIImage(systemName: "star.fill")
    let halfStar = UIImage(systemName: "star.leadinghalf.filled")
    let emptyStar = UIImage(systemName: "star")

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("StarRatingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupStars()
        updateStars()
    }

    private func setupStars() {
        imageViews = stackView.arrangedSubviews.compactMap { $0 as? UIImageView }
        updateStarSizes()
    }

    private func updateStarSizes() {
        imageViews.forEach { imageView in
            imageView.widthAnchor.constraint(equalToConstant: starSize).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: starSize).isActive = true
        }
    }

    private func updateStars() {
        for (index, imageView) in imageViews.enumerated() {
            let starValue = Double(index) + 1
            if rating >= starValue {
                imageView.image = filledStar
            } else if rating >= starValue - 0.5 {
                imageView.image = halfStar
            } else {
                imageView.image = emptyStar
            }
        }
    }
}

