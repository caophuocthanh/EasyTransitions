//
//  ModalTransitionDelegate.swift
//  EasyTransitions
//
//  Created by Marcos Griselli on 07/04/2018.
//

import Foundation

open class ModalTransitionDelegate: NSObject {

    private var animators = [ModalOperation: ModalTransitionAnimator]()
    private let interactiveController = TransitionInteractiveController()
    
    open func wire(viewController: UIViewController, with pan: Pan) {
        interactiveController.wireTo(viewController: viewController, with: pan)
        interactiveController.navigationAction = {
            viewController.dismiss(animated: true, completion: nil)
        }
    }

    open func set(animator: ModalTransitionAnimator, for operation: ModalOperation) {
        animators[operation] = animator
    }
    
    open func removeAnimator(for operation: ModalOperation) {
        animators.removeValue(forKey: operation)
    }
    
    private func configurator(for operation: ModalOperation) -> ModalTransitionConfigurator? {
        guard let animator = animators[operation] else {
            return nil
        }
        return ModalTransitionConfigurator(transitionAnimator: animator)
    }
}

extension ModalTransitionDelegate: UIViewControllerTransitioningDelegate {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return configurator(for: .present)
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return configurator(for: .dismiss)
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveController.interactionInProgress ? interactiveController : nil
    }
}
