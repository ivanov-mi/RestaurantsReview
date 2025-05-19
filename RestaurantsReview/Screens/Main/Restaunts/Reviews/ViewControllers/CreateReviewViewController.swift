//
//  CreateReviewViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/13/25.
//

import UIKit

// MARK: - CreateReviewViewControllerDelegate
protocol CreateReviewViewControllerDelegate: AnyObject {
    func didSubmitReview()
}

// MARK: - CreateReviewViewControllerCoordinator
protocol CreateReviewViewControllerCoordinator: AnyObject {
    func didFinishCreatingReview(_ controller: CreateReviewViewController, review: Review)
    func didCancelReviewCreation(_ controller: CreateReviewViewController)
}

// MARK: - CreateReviewViewController
class CreateReviewViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var starRatingLabel: UILabel!
    @IBOutlet weak private var starRatingView: StarRatingView!
    @IBOutlet weak private var addReviewLabel: UILabel!
    @IBOutlet weak private var commentTextView: UITextView!
    @IBOutlet weak private var datePickerLabel: UILabel!
    @IBOutlet weak private var datePicker: UIDatePicker!

    // MARK: - Properties
    private(set) var userId: UUID!
    private(set) var restaurantId: UUID!
    var reviewToEdit: Review?

    weak var coordinator: CreateReviewViewControllerCoordinator?
    weak var delegate: CreateReviewViewControllerDelegate?
    var persistenceManager: PersistenceManaging!

    var sessionManager: SessionManaging = SessionManager.shared
    
    private var isAdmin: Bool {
        sessionManager.currentUser?.isAdmin ?? false
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validateEditPermissionsIfNeeded()
        setupNavigationBar()
        setupUI()
        setupKeyboardHandling()
        populateIfEditing()
    }

    // MARK: - Public Methods
    func configure(with userId: UUID, for restaurantId: UUID, review: Review? = nil) {
        self.userId = userId
        self.restaurantId = restaurantId
        self.reviewToEdit = review
    }

    // MARK: - Setup
    private func setupNavigationBar() {
        title = reviewToEdit == nil ? "Write a Review" : "Edit Review"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: reviewToEdit == nil ? "Submit" : "Save",
            style: .done,
            target: self,
            action: #selector(submitTapped)
        )
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        starRatingLabel.text = "Tap to rate"
        addReviewLabel.text = "Add your comment"
        datePickerLabel.text = "Date of Visit"

        configureTextView()
        configureDatePicker()
    }

    private func configureTextView() {
        commentTextView.layer.cornerRadius = 10
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.borderColor = UIColor.systemGray4.cgColor
        commentTextView.font = .systemFont(ofSize: 16)
        commentTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    private func configureDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
    }

    private func populateIfEditing() {
        guard let review = reviewToEdit else { return }
        starRatingView.setRating(Double(review.rating))
        commentTextView.text = review.comment
        datePicker.date = review.dateOfVisit
    }

    // MARK: - Keyboard Handling
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        scrollView.contentInset.bottom = keyboardFrame.height
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions
    @objc private func cancelTapped() {
        coordinator?.didCancelReviewCreation(self)
    }

    @objc private func submitTapped() {
        let comment = commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let rating = Int(starRatingView.rating)
        let dateOfVisit = datePicker.date

        guard validateInput(comment: comment, rating: rating) else { return }

        if let reviewToEdit = reviewToEdit {
            updateExistingReview(reviewToEdit, comment: comment, rating: rating, dateOfVisit: dateOfVisit)
        } else {
            createNewReview(comment: comment, rating: rating, dateOfVisit: dateOfVisit)
        }
    }

    // MARK: - Private Helpers
    private func validateEditPermissionsIfNeeded() {
        guard let review = reviewToEdit else { return }

        guard isAdmin || isAuthor(of: review) else {
            showPermissionAlertAndPop()
            return
        }
    }
    
    private func isAuthor(of review: Review) -> Bool {
        sessionManager.currentUser?.id == review.userId
    }
    
    private func validateInput(comment: String, rating: Int) -> Bool {
        if comment.isEmpty || rating <= 0 {
            showAlert(title: "Incomplete", message: "Please provide both a rating and a comment.")
            return false
        }
        return true
    }

    private func updateExistingReview(_ original: Review, comment: String, rating: Int, dateOfVisit: Date) {
        guard let review = persistenceManager.updateReview(
            reviewId: original.id,
            newComment: comment,
            newRating: rating,
            newDateOfVisit: dateOfVisit
        ) else {
            showAlert(title: "Error", message: "Failed to update review.")
            return
        }

        delegate?.didSubmitReview()
        coordinator?.didFinishCreatingReview(self, review: review)
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

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: { _ in completion?() }))
        present(alert, animated: true)
    }

    private func showPermissionAlertAndPop() {
        showAlert(title: "Not Allowed", message: "You don't have permission to edit this review.") {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
