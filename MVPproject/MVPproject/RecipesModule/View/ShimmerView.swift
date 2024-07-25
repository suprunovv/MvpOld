// ShimmerView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Заглушка с шимером
final class ShimmerView: UIView {
    private enum Constants {}

    // MARK: - Private properties

    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemGray3.cgColor, UIColor.systemGray2.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }()

    // MARK: - Initializators

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShimmerAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func setupShimmerAnimation() {
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.25]
        animation.toValue = [0.75, 1.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: SwiftGenStrings.ShimerView.gadientKey)
    }
}
