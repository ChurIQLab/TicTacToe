//
//  Figure+Path.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 23.09.2026.
//

import UIKit

extension Figure {

    // MARK: - Properties

    /// Side of the grid the outlines are drawn in
    static let gridSize: CGFloat = 56
    static let lineWidth: CGFloat = 7.5

    /// Outline in the `gridSize` grid; the stroke goes in the drawing order
    var path: UIBezierPath {
        switch self {
        case .cross:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 13, y: 13))
            path.addLine(to: CGPoint(x: 43, y: 43))
            path.move(to: CGPoint(x: 43, y: 13))
            path.addLine(to: CGPoint(x: 13, y: 43))
            return path
        case .circle:
            return UIBezierPath(
                arcCenter: CGPoint(x: 28, y: 28),
                radius: 17,
                startAngle: -.pi / 2,
                endAngle: .pi * 3 / 2,
                clockwise: true
            )
        }
    }

    // MARK: - Methods

    /// Draws the outline for inline use in text, e.g. in a text attachment
    func image(size: CGFloat, color: UIColor) -> UIImage {
        let scale = size / Self.gridSize
        let path = path
        path.apply(CGAffineTransform(scaleX: scale, y: scale))
        path.lineWidth = Self.lineWidth * scale
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        return UIGraphicsImageRenderer(size: CGSize(width: size, height: size)).image { _ in
            color.setStroke()
            path.stroke()
        }
    }
}
