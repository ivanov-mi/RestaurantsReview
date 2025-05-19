//
//  ReviewListItemView.swift
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

class ReviewListItemView: UIView {
   
    // MARK: - IBOutlets
    @IBOutlet private weak var tagsStackView: UIStackView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    // MARK: - Properties
    var onTap: (() -> Void)?
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTapGesture()
        applyShadow()
    }
    
    // MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadFromNib()
        applyShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadFromNib()
        applyShadow() 
    }
    
    // MARK: - Configuration
    func configure(tags: Set<ReviewListItemType>, ratingFormatted: String, comment: String) {
        configureTags(tags)
        ratingLabel.text = ratingFormatted
        titleLabel.text = comment
    }
    
    // MARK: - Actions
    @objc private func viewTapped() {
        onTap?()
    }
    
    // MARK: - Private methods
    private func loadFromNib() {
        let nib = UINib(nibName: ReviewListItemView.identifier, bundle: nil)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    private func applyShadow() {
        self.applyDefaultShadow()
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
    }
    
    private func configureTags(_ tags: Set<ReviewListItemType>) {
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let shouldHideTags = tags.isEmpty || tags.count >= ReviewListItemType.allCases.count
        tagsStackView.isHidden = shouldHideTags
        guard !shouldHideTags else { return }

        tagsStackView.spacing = 8

        tags.forEach { tag in
            let label = makeTagLabel(for: tag)
            tagsStackView.addArrangedSubview(label)
        }

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tagsStackView.addArrangedSubview(spacer)
    }

    private func makeTagLabel(for tag: ReviewListItemType) -> UILabel {
        let label = UILabel()
        label.text = tag.description
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = tag.textColor
        label.textAlignment = .left
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }
}
