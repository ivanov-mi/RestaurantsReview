//
//  CreateReviewViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/13/25.
//

import UIKit

protocol CreateReviewViewControllerDelegate: AnyObject {
    func didSubmitReview(_ review: Review)
    func didCancelReview()
}

class CreateReviewViewController: UIViewController {
    
    @IBOutlet weak var starRatingLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var addReviewLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var datePickerLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    weak var delegate: CreateReviewViewControllerDelegate?
    var userId: UUID!

    private func configureRatingLabel() {
        starRatingLabel.text = "Tap to rate"
    }
    
    private func confugureAddReviewLabel() {
        addReviewLabel.text = "Add your comment"
    }

    private func configureTextView() {
        commentTextView.layer.cornerRadius = 10
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.borderColor = UIColor.systemGray4.cgColor
        commentTextView.font = .systemFont(ofSize: 16)
    }
    
    private func configureDatePickerLabel() {
        datePickerLabel.text = "Date of Visit"
    }

    private func configure() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        setupKeyboardObservers()
        setupDismissKeyboardOnTap()
    }

    // MARK: - Setup Methods
    private func setupNavigationBar() {
        title = "Write a Review"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Submit",
            style: .done,
            target: self,
            action: #selector(submitTapped)
        )
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground

        configureRatingLabel()
        confugureAddReviewLabel()
        configureTextView()
        configureDatePickerLabel()
        configure()
    }

    // MARK: - Actions
    @objc private func cancelTapped() {
        delegate?.didCancelReview()
        dismiss(animated: true)
    }

    @objc private func submitTapped() {
        let comment = commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let rating = Int(starRatingView.rating)

        guard !comment.isEmpty, rating > 0 else {
            showAlert(title: "Incomplete", message: "Please provide both a rating and a comment.")
            return
        }

        let review = Review(
            userId: userId,
            comment: comment,
            rating: rating,
            dateOfVisit: datePicker.date,
            dateCreated: Date()
        )

        delegate?.didSubmitReview(review)
        dismiss(animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupDismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let bottomInset = keyboardFrame.height
        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
