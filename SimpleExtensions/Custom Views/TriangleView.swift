//
//  TriangleView.swift
//  SimpleExtensions
//
//  Created by Marc Etcheverry on 6/6/18.
//  Copyright © 2018 Tap Light Software. All rights reserved.
//

import UIKit

// Int so it can be @IBInspectable. In the future we may want to specify different types of triangles with different pointing directions
enum TriangleGeometry {
    case topPointing
    case rightPointing
    case leftPointing
    case bottomPointing

    /// A tuple of points starting with the base start, base end, and the apex
    func anchorPoints(forBounds bounds: CGRect) -> (CGPoint, CGPoint, CGPoint) {
        switch self {
        case .topPointing:
            return (CGPoint(x: 0, y: bounds.height),
                    CGPoint(x: bounds.width, y: bounds.height),
                    CGPoint(x: bounds.midX, y: 0))
        case .rightPointing:
            return (CGPoint(x: 0, y: 0),
                    CGPoint(x: 0, y: bounds.height),
                    CGPoint(x: bounds.width, y: bounds.midY))
        case .leftPointing:
            return (CGPoint(x: bounds.width, y: 0),
                    CGPoint(x: bounds.width, y: bounds.height),
                    CGPoint(x: 0, y: bounds.midY))
        case .bottomPointing:
            return (CGPoint(x: 0, y: 0),
                    CGPoint(x: bounds.width, y: 0),
                    CGPoint(x: bounds.midX, y: bounds.height))
        }
    }
}

@IBDesignable class TriangleView: UIView {
    var geometry: TriangleGeometry = .rightPointing
    @IBInspectable var fillColor: UIColor? {
        get {
            if let triangleFillColor = triangleLayer.fillColor {
                return UIColor(cgColor: triangleFillColor)
            }

            return nil
        }
        set {
            triangleLayer.fillColor = newValue?.cgColor
            layoutSubviews()
        }
    }

    private lazy var triangleLayer: CAShapeLayer = {
        let triangleLayer = CAShapeLayer()
        layer.addSublayer(triangleLayer)
        return triangleLayer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        let path = UIBezierPath()

        let (baseStart, baseEnd, apex) = geometry.anchorPoints(forBounds: bounds)
        path.move(to: baseStart)
        path.addLine(to: baseEnd)
        path.addLine(to: apex)
        path.close()
        triangleLayer.path = path.cgPath
    }
}
