//
//  SizeChangingPageControl.swift
//  SimpleExtensions
//
//  Created by Marc Etcheverry on 6/6/18.
//  Copyright © 2018 Tap Light Software. All rights reserved.
//

import UIKit

/// UIPageControl drop in replacement with custom sizing for all dots, differential inset sizing for the current dot, and animated transitions. Supports iOS 10 and 11 properties for layout margins
class SizeChangingPageControl : UIControl {
    private var _numberOfPages: Int = 0

    var numberOfPages: Int {
        get {
            return _numberOfPages
        }
        set {
            setNumberOfPages(newValue)
        }
    }

    private func setNumberOfPages(_ number: Int) {
        if number == _numberOfPages {
            return
        }

        if number < 0 {
            _numberOfPages = 0
        }
        else {
            _numberOfPages = number
        }

        let difference = indicatorLayers.count - numberOfPages
        repeat {
            if difference < 0 {
                let indicatorLayer = CAShapeLayer()
                indicatorLayer.fillColor = pageIndicatorTintColor.cgColor
                indicatorLayers.append(indicatorLayer)
                layer.addSublayer(indicatorLayer)
            }
            else {
                indicatorLayers.last?.removeFromSuperlayer()
                indicatorLayers.removeLast()
            }
        } while indicatorLayers.count != numberOfPages

        if currentPage >= numberOfPages {
            oldCurrentIndicatorLayer = nil
            _currentPage = 0
        }

        updateCurrentPageIndicatorSizeAndColor(animated: false)

        setNeedsLayout()
        layoutIfNeeded()
    }

    private var _currentPage: Int = 0

    var currentPage: Int {
        get {
            return _currentPage
        }
        set {
            setCurrentPage(newValue, animated: false)
        }
    }
	
    func setCurrentPage(_ page: Int, animated: Bool) {
        if page == _currentPage {
            return
        }

        oldCurrentIndicatorLayer = currentIndicatorLayer

        if page < 0 {
            _currentPage = 0
        }
        else if page >= numberOfPages {
            if numberOfPages > 0 {
                _currentPage = numberOfPages - 1
            }
            else {
                _currentPage = 0
            }
        }
        else {
            _currentPage = page
        }

        updateCurrentPageIndicatorSizeAndColor(animated: animated)
    }

    var pageIndicatorTintColor: UIColor = UIColor(red: 195 / 255, green: 195 / 255, blue: 195 / 255, alpha: 1) {
        didSet {
            for indicatorLayer in indicatorLayers {
                if indicatorLayer != currentIndicatorLayer {
                    indicatorLayer.fillColor = pageIndicatorTintColor.cgColor
                }
            }
        }
    }

    var currentPageIndicatorTintColor: UIColor = UIColor(red: 115 / 255, green: 115 / 255, blue: 115 / 255, alpha: 1) {
        didSet {
            currentIndicatorLayer?.fillColor = currentPageIndicatorTintColor.cgColor
        }
    }

    var pageIndicatorSize: CGSize = CGSize(width: 2, height: 2) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var currentPageIndicatorSizeInset: CGSize = CGSize(width: -1, height: -1) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var interPageIndicatorSpacing: CGFloat = 4 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    // MARK: - Private Properties

    private var currentPageIndicatorSize: CGSize {
        get {
            return CGSize(width: pageIndicatorSize.width - currentPageIndicatorSizeInset.width,
                          height: pageIndicatorSize.height - currentPageIndicatorSizeInset.height)
        }
    }

    private var maxPageIndicatorSize: CGSize {
        get {
            return CGSize(width: max(pageIndicatorSize.width, currentPageIndicatorSize.width),
                          height: max(pageIndicatorSize.height, currentPageIndicatorSize.height))
        }
    }

    private lazy var indicatorLayers = [CAShapeLayer]()
    private weak var currentIndicatorLayer: CAShapeLayer? {
        get {
            return indicatorLayers[safe: currentPage]
        }
    }

    private weak var oldCurrentIndicatorLayer: CAShapeLayer?

    // MARK: - Private Functions

    private func shapePathForIndicatorLayer(atIndex index: Int) -> CGPath {
        let indicatorLayer = indicatorLayers[index]
        var ovalRect = indicatorLayer.bounds
        if index == currentPage {
            ovalRect = ovalRect.insetBy(dx: currentPageIndicatorSizeInset.width,
                                        dy: currentPageIndicatorSizeInset.height)
        }

        return UIBezierPath(ovalIn: ovalRect).cgPath
    }

    private func updateCurrentPageIndicatorSizeAndColor(animated: Bool) {
        // This should eventually be localized when full acessibility support is enabled
        accessibilityValue = NSLocalizedString("page \(currentPage) of \(numberOfPages)", comment: "")

        guard numberOfPages > 0 else {
            return
        }

        if animated {
            if let oldCurrentIndicatorLayer = oldCurrentIndicatorLayer {
                let oldAnimationForPath = CABasicAnimation(keyPath: "path")
                oldAnimationForPath.toValue = UIBezierPath(ovalIn: oldCurrentIndicatorLayer.bounds).cgPath

                let oldAnimationForColor = CABasicAnimation(keyPath: "fillColor")
                oldAnimationForColor.toValue = pageIndicatorTintColor.cgColor

                let oldPathAndColorAnimationGroup = CAAnimationGroup()
                oldPathAndColorAnimationGroup.animations = [oldAnimationForPath, oldAnimationForColor]
                oldPathAndColorAnimationGroup.duration = 0.3
                oldPathAndColorAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                oldPathAndColorAnimationGroup.fillMode = kCAFillModeForwards
                oldPathAndColorAnimationGroup.isRemovedOnCompletion = false
                oldCurrentIndicatorLayer.add(oldPathAndColorAnimationGroup, forKey: nil)
            }

            let animationForPath = CABasicAnimation(keyPath: "path")
            animationForPath.toValue = shapePathForIndicatorLayer(atIndex: currentPage)

            let animationForColor = CABasicAnimation(keyPath: "fillColor")
            animationForColor.toValue = currentPageIndicatorTintColor.cgColor

            let pathAndColorAnimationGroup = CAAnimationGroup()
            pathAndColorAnimationGroup.animations = [animationForPath, animationForColor]
            pathAndColorAnimationGroup.duration = 0.3
            pathAndColorAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            pathAndColorAnimationGroup.fillMode = kCAFillModeForwards
            pathAndColorAnimationGroup.isRemovedOnCompletion = false

            currentIndicatorLayer?.add(pathAndColorAnimationGroup, forKey: nil)
        }
        else {
            if let oldCurrentIndicatorLayer = oldCurrentIndicatorLayer {
                oldCurrentIndicatorLayer.fillColor = pageIndicatorTintColor.cgColor
                oldCurrentIndicatorLayer.path = UIBezierPath(ovalIn: oldCurrentIndicatorLayer.bounds).cgPath
            }

            currentIndicatorLayer?.fillColor = currentPageIndicatorTintColor.cgColor
            currentIndicatorLayer?.path = shapePathForIndicatorLayer(atIndex: currentPage)
        }
    }

    private var adjustedLayoutMargins: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return UIEdgeInsets(top: directionalLayoutMargins.top + abs(currentPageIndicatorSizeInset.height),
                                    left: directionalLayoutMargins.leading + abs(currentPageIndicatorSizeInset.width),
                                    bottom: directionalLayoutMargins.bottom + abs(currentPageIndicatorSizeInset.height),
                                    right: directionalLayoutMargins.trailing + abs(currentPageIndicatorSizeInset.width))
            }

            var insetLayoutMargins = layoutMargins
            insetLayoutMargins.left += abs(currentPageIndicatorSizeInset.width)
            insetLayoutMargins.right += abs(currentPageIndicatorSizeInset.width)
            insetLayoutMargins.top += abs(currentPageIndicatorSizeInset.height)
            insetLayoutMargins.bottom += abs(currentPageIndicatorSizeInset.height)
            return insetLayoutMargins
        }
        set {
            if #available(iOS 11.0, *) {
                directionalLayoutMargins = NSDirectionalEdgeInsets(top: layoutMargins.top, leading: layoutMargins.left, bottom: layoutMargins.bottom, trailing: layoutMargins.right)
            }
            else {
                layoutMargins = newValue
            }
        }
    }

    private var widthOfAllIndicators: CGFloat {
        get {
            return (CGFloat(numberOfPages) * maxPageIndicatorSize.width) + ((CGFloat(numberOfPages) - 1) * interPageIndicatorSpacing)
        }
    }

    // MARK: - Init

    private func commonInit() {
        accessibilityTraits = UIAccessibilityTraitUpdatesFrequently | UIAccessibilityTraitAdjustable
        isAccessibilityElement = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()

    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        let initialOriginX = abs((bounds.size.width / 2) - (widthOfAllIndicators / 2))
        var lastIndicatorMaxX = initialOriginX

        for (index, indicatorLayer) in indicatorLayers.enumerated() {
            indicatorLayer.frame.origin = CGPoint(x: lastIndicatorMaxX, y: adjustedLayoutMargins.top)
            indicatorLayer.frame.size = maxPageIndicatorSize
            indicatorLayer.path = shapePathForIndicatorLayer(atIndex: index)
            lastIndicatorMaxX = indicatorLayer.frame.maxX + interPageIndicatorSpacing
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: adjustedLayoutMargins.left + widthOfAllIndicators + adjustedLayoutMargins.right,
                      height: adjustedLayoutMargins.top + maxPageIndicatorSize.height + adjustedLayoutMargins.bottom)
    }

    // MARK: - Touch Handling

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            let pressPoint = touch.location(in: self)
            let midPoint = (bounds.size.width / 2)
            if pressPoint.x > midPoint
            {
                switchToNextPage()
            }
            else if pressPoint.x < midPoint
            {
                switchToPreviousPage()
            }
        }
    }

    // MARK: - Page Switching

    private func switchToNextPage() {
        if currentPage < (numberOfPages - 1) {
            setCurrentPage(currentPage + 1, animated: true)
            sendActions(for: .valueChanged)
            // UIPageControl sends a private 4002 with { event = TouchEventsCompleted }
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self)
        }
    }

    private func switchToPreviousPage() {
        if currentPage > 0 {
            setCurrentPage(currentPage - 1, animated: true)
            sendActions(for: .valueChanged)
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self)
        }
    }

    // MARK: - Accessibility

    override func accessibilityIncrement() {
        super.accessibilityIncrement()
        switchToNextPage()
    }

    override func accessibilityDecrement() {
        super.accessibilityDecrement()
        switchToPreviousPage()
    }
}
