//
//  BottomSheetPresentationController.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 23.09.2026.
//

import UIKit

/// Presents a sheet edge to edge at the bottom over a scrim; the sheet is as tall as its content.
/// The content is laid out in the layout margins of the presented view: they hold the sheet paddings
/// and the bottom safe area. Closes by a tap on the scrim or a swipe down.
final class BottomSheetPresentationController: UIPresentationController {

    // MARK: - Properties

    private let dimmingView = UIView()

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView, let presentedView else { return .zero }
        updateMargins(of: presentedView, in: containerView)
        let bounds = containerView.bounds
        let fittingSize = presentedView.systemLayoutSizeFitting(
            CGSize(width: bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        let height = min(fittingSize.height, bounds.height - containerView.safeAreaInsets.top)
        return CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
    }

    // MARK: - Lifecycle

    override func presentationTransitionWillBegin() {
        guard let containerView, let presentedView else { return }
        setupDimmingView(in: containerView)
        setupSheet(presentedView)

        dimmingView.alpha = 0
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1
            return
        }
        transitionCoordinator.animate { [weak self] _ in
            self?.dimmingView.alpha = 1
        }
    }

    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0
            return
        }
        transitionCoordinator.animate { [weak self] _ in
            self?.dimmingView.alpha = 0
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    // MARK: - Setups

    private func setupDimmingView(in containerView: UIView) {
        dimmingView.backgroundColor = .scrim
        dimmingView.frame = containerView.bounds
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped)))
        containerView.insertSubview(dimmingView, at: 0)
    }

    private func setupSheet(_ presentedView: UIView) {
        presentedView.backgroundColor = .surface
        presentedView.layer.cornerRadius = CornerRadius.sheet
        presentedView.layer.cornerCurve = .continuous
        presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedView.clipsToBounds = true
        presentedView.accessibilityViewIsModal = true
        presentedView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sheetPanned)))
    }

    // MARK: - Private methods

    private func updateMargins(of presentedView: UIView, in containerView: UIView) {
        presentedView.insetsLayoutMarginsFromSafeArea = false
        presentedView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Constants.topPadding,
            leading: Constants.sidePadding,
            bottom: max(containerView.safeAreaInsets.bottom + Constants.bottomPadding, Constants.minimumBottomPadding),
            trailing: Constants.sidePadding
        )
    }

    @objc private func dimmingViewTapped() {
        presentedViewController.dismiss(animated: true)
    }

    @objc private func sheetPanned(_ gesture: UIPanGestureRecognizer) {
        guard let presentedView else { return }
        let translation = max(gesture.translation(in: presentedView).y, 0)
        let progress = translation / max(presentedView.bounds.height, 1)

        switch gesture.state {
        case .changed:
            presentedView.transform = CGAffineTransform(translationX: 0, y: translation)
            dimmingView.alpha = 1 - progress
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: presentedView).y
            let shouldDismiss = gesture.state == .ended
                && (progress > Constants.dismissProgress || velocity > Constants.dismissVelocity)
            if shouldDismiss {
                finishSwipe()
            } else {
                cancelSwipe()
            }
        default:
            break
        }
    }

    private func finishSwipe() {
        guard let presentedView else { return }
        let duration = Constants.swipeAnimationDuration
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) { [weak self] in
            presentedView.transform = CGAffineTransform(translationX: 0, y: presentedView.bounds.height)
            self?.dimmingView.alpha = 0
        } completion: { [weak self] _ in
            self?.presentedViewController.dismiss(animated: false)
        }
    }

    private func cancelSwipe() {
        UIView.animate(withDuration: Constants.swipeAnimationDuration) { [weak self] in
            self?.presentedView?.transform = .identity
            self?.dimmingView.alpha = 1
        }
    }
}

// MARK: - Constants

extension BottomSheetPresentationController {
    struct Constants {
        static let topPadding: CGFloat = 8
        static let sidePadding: CGFloat = 24
        /// Above the bottom safe area, but not less than `minimumBottomPadding` from the screen edge
        static let bottomPadding: CGFloat = 8
        static let minimumBottomPadding: CGFloat = 24
        static let dismissProgress: CGFloat = 0.3
        static let dismissVelocity: CGFloat = 1000
        static let swipeAnimationDuration: TimeInterval = 0.25
    }
}

// MARK: - BottomSheetTransitioningDelegate

/// Keep a strong reference: `transitioningDelegate` of a view controller is weak
final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
