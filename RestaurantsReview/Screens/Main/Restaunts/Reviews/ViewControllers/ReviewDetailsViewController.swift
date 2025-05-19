//
//  ReviewDetailsViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/13/25.
//

import UIKit

// MARK: - ReviewScreenMode
enum ReviewScreenMode {
    case viewing
    case editing
}

// MARK: - ReviewDetailsViewControllerDelegate
protocol ReviewDetailsViewControllerDelegate: AnyObject {
    func didSubmitReview()
}

// MARK: - ReviewDetailsViewControllerCoordinator
protocol ReviewDetailsViewControllerCoordinator: AnyObject {
    func didFinishCreatingReview(_ controller: ReviewDetailsViewController, review: Review)
    func didCancelReviewCreation(_ controller: ReviewDetailsViewController)
}

// MARK: - ReviewDetailsViewController
class ReviewDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var starRatingLabel: UILabel!
    @IBOutlet private weak var starRatingView: StarRatingView!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var datePickerLabel: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var authorLabel: UILabel!
    

    // MARK: - Properties
    private(set) var userId: UUID!
    private(set) var restaurantId: UUID!
    private(set) var reviewToEdit: Review?
    
    var persistenceManager: PersistenceManaging!
    weak var coordinator: ReviewDetailsViewControllerCoordinator?
    weak var delegate: ReviewDetailsViewControllerDelegate?
    
    var sessionManager: SessionManaging = SessionManager.shared
    
    private var authorName: String?
    private var mode: ReviewScreenMode = .viewing {
        didSet {
            updateUIState()
        }
    }
    
    private var isEditable: Bool {
        guard let currentUser = sessionManager.currentUser,
              let review = reviewToEdit else {
            return false
        }
        
        return currentUser.isAdmin || currentUser.id == review.userId
    }
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardHandling()
        populateWithReviewToEdit()
    }
    
    // MARK: - Public Methods
    func configure(with userId: UUID, for restaurantId: UUID, review: Review? = nil) {
        self.userId = userId
        self.restaurantId = restaurantId
        self.reviewToEdit = review
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = reviewToEdit == nil ? "Add Review" : "Review"
        commentLabel.text = "Comment"
        
        if let review = reviewToEdit {
            let author = fetchAuthorName(for: review.userId)
            authorLabel.text = "Author: \(author)"
            authorLabel.isHidden = false
        } else {
            authorLabel.isHidden = true
        }
        
        if reviewToEdit == nil {
            mode = .editing
        } else {
            mode = .viewing
        }
        
        let isEditing = (mode == .editing)
        enableFields(isEditing)
        updateUIState()
    }
    
    private func enableFields(_ enabled: Bool) {
        starRatingView.isUserInteractionEnabled = enabled
        commentTextView.isEditable = enabled
        datePicker.isEnabled = enabled
        
        starRatingLabel.text = "Tap to rate"
    }
    
    private func updateUIState() {
        updateLeftBarButton()
        updateRightBarButton()

        let isEditing = (mode == .editing)
        enableFields(isEditing)
    }
    
    private func updateLeftBarButton() {
        switch mode {
        case .editing:
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(cancelTapped)
            )
        case .viewing:
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    private func updateRightBarButton() {
        switch mode {
        case .editing:
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self,
                action: #selector(submitTapped)
            )
        case .viewing:
            if reviewToEdit != nil && isEditable {
                navigationItem.rightBarButtonItem = UIBarButtonItem(
                    title: "Edit",
                    style: .plain,
                    target: self,
                    action: #selector(editTapped)
                )
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    // MARK: - Actions
    @objc private func editTapped() {
        mode = .editing
    }
    
    @objc private func cancelTapped() {
        mode = .viewing
        populateWithReviewToEdit()
    }
    
    @objc private func submitTapped() {
        let comment = commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let rating = Int(starRatingView.rating)
        let dateOfVisit = datePicker.date
        
        guard !comment.isEmpty, rating > 0 else {
            showAlert(title: "Incomplete", message: "Please provide both a rating and a comment.")
            return
        }
        
        if let reviewToEdit = reviewToEdit {
            updateExistingReview(reviewToEdit, comment: comment, rating: rating, dateOfVisit: dateOfVisit)
        } else {
            createNewReview(comment: comment, rating: rating, dateOfVisit: dateOfVisit)
        }
    }
    
    // MARK: - Private Helpers
    private func fetchAuthorName(for userId: UUID) -> String {
        return persistenceManager
            .fetchAllUsers()
            .first(where: { $0.id == userId })?
            .username ?? "Unknown"
    }
    

    private func updateExistingReview(_ original: Review, comment: String, rating: Int, dateOfVisit: Date) {
        guard let updated = persistenceManager.updateReview(
            reviewId: original.id,
            newComment: comment,
            newRating: rating,
            newDateOfVisit: dateOfVisit
        ) else {
            showAlert(title: "Error", message: "Failed to update review.")
            return
        }
        
        delegate?.didSubmitReview()
        coordinator?.didFinishCreatingReview(self, review: updated)
    }
    
    private func createNewReview(comment: String, rating: Int, dateOfVisit: Date) {
        guard let review = persistenceManager.addReview(
            restaurantId: restaurantId,
            userId: userId,
            comment: comment,
            rating: rating,
            dateOfVisit: dateOfVisit
        ) else {
            showAlert(title: "Error", message: "Failed to create review.")
            return
        }
        
        delegate?.didSubmitReview()
        coordinator?.didFinishCreatingReview(self, review: review)
    }
    
    private func populateWithReviewToEdit() {
        guard let review = reviewToEdit else { return }
        starRatingView.setRating(Double(review.rating))
        commentTextView.text = review.comment
        datePicker.date = review.dateOfVisit
        
        starRatingLabel.text = "Rating (\(review.rating)/5)"
    }
    
    // MARK: - Keyboard
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Alerts
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

