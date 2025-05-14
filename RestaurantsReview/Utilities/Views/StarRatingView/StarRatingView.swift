//
//  StarRatingView.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/13/25.
//

import UIKit

protocol StarRatingViewDelegate: AnyObject {
    func starRatingView(_ view: StarRatingView, didChangeRating rating: Double)
}

@IBDesignable
class StarRatingView: UIView {

    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!

    // MARK: - Properties
    private var starButtons: [UIButton] = []
    private(set) var rating: Double = 0 {
        didSet { updateStars() }
    }

    weak var delegate: StarRatingViewDelegate?

    // MARK: - Init
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

        starButtons = [star1Button, star2Button, star3Button, star4Button, star5Button]
        updateStars()
    }

    // MARK: - Actions
    @IBAction func starTapped(_ sender: UIButton) {
        guard let index = starButtons.firstIndex(of: sender) else { return }

        let selectedRating = Double(index + 1) // whole stars only
        rating = selectedRating
        delegate?.starRatingView(self, didChangeRating: selectedRating)
    }

    // MARK: - UI Update
    private func updateStars() {
        for (index, button) in starButtons.enumerated() {
            let fullIndex = Double(index)
            let imageName: String

            if fullIndex + 1 <= rating {
                imageName = "star.fill"
            } else if fullIndex + 0.5 <= rating {
                imageName = "star.leadinghalf.filled"
            } else {
                imageName = "star"
            }

            button.setImage(UIImage(systemName: imageName), for: .normal)
            button.tintColor = .systemYellow
        }
    }

    // MARK: - Public API
    func setRating(_ value: Double) {
        rating = max(0, min(5, value))
    }
}


