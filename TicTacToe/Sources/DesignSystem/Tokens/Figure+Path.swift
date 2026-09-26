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
        case .triangle:
            return Self.polygon([(28, 11), (45, 42), (11, 42)])
        case .square:
            return Self.polygon([(13, 13), (43, 13), (43, 43), (13, 43)])
        case .diamond:
            return Self.polygon([(28, 9), (47, 28), (28, 47), (9, 28)])
        case .star:
            return Self.polygon([
                (28, 10), (32.8, 22.4), (46.1, 23.1), (35.8, 31.5), (39.2, 44.4),
                (28, 37.2), (16.8, 44.4), (20.2, 31.5), (9.9, 23.1), (23.2, 22.4)
            ])
        case .heart:
            return Self.heartPath
        case .hexagon:
            return Self.polygon([(28, 9), (44.5, 18.5), (44.5, 37.5), (28, 47), (11.5, 37.5), (11.5, 18.5)])
        }
    }

    /// Two halves from the bottom tip to the dip at the top and back
    private static var heartPath: UIBezierPath {
        // End point, then two control points of each curve
        let curves: [[(x: CGFloat, y: CGFloat)]] = [
            [(11, 23.5), (19, 38), (11, 32)],
            [(19.5, 15), (11, 18.5), (15, 15)],
            [(28, 20.5), (23.5, 15), (26, 17.5)],
            [(36.5, 15), (30, 17.5), (32.5, 15)],
            [(45, 23.5), (41, 15), (45, 18.5)],
            [(28, 45), (45, 32), (37, 38)]
        ]
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 28, y: 45))
        for curve in curves {
            let points = curve.map { CGPoint(x: $0.x, y: $0.y) }
            path.addCurve(to: points[0], controlPoint1: points[1], controlPoint2: points[2])
        }
        path.close()
        return path
    }

    /// Closed outline through the vertices in order
    private static func polygon(_ vertices: [(x: CGFloat, y: CGFloat)]) -> UIBezierPath {
        let path = UIBezierPath()
        for (index, vertex) in vertices.enumerated() {
            let point = CGPoint(x: vertex.x, y: vertex.y)
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.close()
        return path
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
