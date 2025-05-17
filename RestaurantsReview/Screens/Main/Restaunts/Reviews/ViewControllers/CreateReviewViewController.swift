//
//  CreateReviewViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/13/25.
//

import UIKit

// MARK: - CreateReviewViewControllerDelegate
protocol CreateReviewViewControllerDelegate: AnyObject {
    func didSubmitReview(_ review: Review)
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
    var userId: UUID!
    
    weak var coordinator: CreateReviewViewControllerCoordinator?
    weak var delegate: CreateReviewViewControllerDelegate?

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupKeyboardHandling()
    }

    // MARK: - Setup
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

    private func setupUI() {
        view.backgroundColor = .systemBackground

        configureLabels()
        configureTextView()
        configureDatePicker()
    }

    private func configureLabels() {
        starRatingLabel.text = "Tap to rate"
        addReviewLabel.text = "Add your comment"
        datePickerLabel.text = "Date of Visit"
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
        coordinator?.didFinishCreatingReview(self, review: review)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

