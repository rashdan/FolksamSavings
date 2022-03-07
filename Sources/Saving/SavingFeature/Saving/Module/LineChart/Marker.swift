import UIKit

class Marker: CAShapeLayer {
    init(strokeColor: CGColor, fillColor: CGColor, lineWidth: CGFloat) {
        super.init()
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.lineWidth = lineWidth
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func triangleDown() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width / 2.0, y: frame.height))
        path.close()
        self.path = path.cgPath
    }

    func triangleUp() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: frame.height))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: frame.width / 2.0, y: 0))
        path.close()
        self.path = path.cgPath
    }

    func circle() {
        let path = UIBezierPath(ovalIn: bounds)
        self.path = path.cgPath
    }

    // override func layoutSublayers() {
    // triangleDown()
    // }
}
