//
//  CustomReviewListingView.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import UIKit

enum ReviewListItemType: CaseIterable {
    case highestRated
    case mostRecent
    case lowestRated
    
    var textColor: UIColor {
        switch self {
        case .highestRated:
            return .green
        case .mostRecent:
            return .systemGray
        case .lowestRated:
            return .systemRed
        }
    }
    
    var description: String {
        switch self {
        case .highestRated:
            return "Highest Rated"
        case .mostRecent:
            return "Most Recent"
        case .lowestRated:
            return "Lowest Rated"
        }
    }
}

struct ReviewListItemViewModel {
    var tags: Set<ReviewListItemType>
    let rating: Int
    let comment: String
    
    var ratingFormated: String {
        "\(rating) / 5"
    }
    
    init(tags: Set<ReviewListItemType>, rating: Int, comment: String) {
        self.tags = tags
        self.rating = rating
        self.comment = comment
    }
}

class ReviewListItemView: UIView {
   
    @IBOutlet weak var tagsStackView: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupRoundShadow()
    }
    
    // MARK: - Private methods
    
    private func setupRoundShadow() {
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
        setupRoundShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        setupRoundShadow() 
    }
    
    func configure(with viewModel: ReviewListItemViewModel) {
        if viewModel.tags.isEmpty || viewModel.tags.count >= ReviewListItemType.allCases.count {
            tagsStackView.isHidden = true
        } else {
            configureTagsStackView(viewModel)
        }
        
        ratingLabel.text = viewModel.ratingFormated
        titleLabel.text = viewModel.comment
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: ReviewListItemView.identifier, bundle: nil)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    private func configureTagsStackView(_ viewModel: ReviewListItemViewModel) {
        tagsStackView.isHidden = false
        for tag in viewModel.tags {
            let label = UILabel()
            label.text = tag.description
            label.font = .systemFont(ofSize: 12, weight: .medium)
            label.textColor = tag.textColor
            label.textAlignment = .left
            label.layer.cornerRadius = 6
            label.clipsToBounds = true
            label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 20).isActive = true
            tagsStackView.spacing = 8
            tagsStackView.addArrangedSubview(label)
        }
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tagsStackView.addArrangedSubview(spacer)
    }
}
