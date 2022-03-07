//
//  LineChart.swift
//  LineChart
//
//  Created by Nguyen Vu Nhat Minh on 25/8/17.
//  Copyright © 2017 Nguyen Vu Nhat Minh. All rights reserved.
//
import UIKit

class LineChart: UIView {
//    let chartBgColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    let chartBgColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    // let gradientColors = [#colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 0.7039046129), #colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 0.2974168386)]
    let gradientColors = [#colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 0.8972362998), #colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 0)]

    let gridColor = #colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 1)
    let labelWidth: CGFloat = 50.0

//    let defaultLineColor = #colorLiteral(red: 0.6431372549, green: 0.7607843137, blue: 0.03137254902, alpha: 1)
    // let defaultLineColor = #colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 1)
    let defaultLineColor = #colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 0.5993048055)

    let dotInnerColor = #colorLiteral(red: 0.8235294118, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
    let dotBgColor = #colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 1)

    let goalMarkerSize: CGFloat = 10
    let goalMarkerLineWidth: CGFloat = 2
    let markerSize: CGFloat = 8
    let markerLineWidth: CGFloat = 1.5

    let goalMarkerFillColor = #colorLiteral(red: 0.8235294118, green: 0.8823529412, blue: 0.5098039216, alpha: 1).cgColor
    let goalMarkerStrokeColor = #colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 1).cgColor
    let markerFillColors = [#colorLiteral(red: 0.9411764706, green: 0.6470588235, blue: 0.7647058824, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.4901960784, green: 0.7843137255, blue: 0.9411764706, alpha: 1).cgColor]
    let markerStrokeColors = [#colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 1).cgColor, #colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 1).cgColor, #colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 1).cgColor]

    /// preseved space at top of the chart
    let topSpace: CGFloat = 40.0
    /// preserved space at bottom of the chart to show labels along the Y axis
    let bottomSpace: CGFloat = 40.0

    let mainLineWidth: CGFloat = 2.0

    var lineGap = CGFloat()
    var chartMin = CGFloat()
    var chartMax = CGFloat()
    var chartRange = CGFloat()
    var chartRes = CGFloat()
    var chartMaxGrowth: Double = 2.0

    let curveTopOffset: CGFloat = 0.0
    let curveBottomOffset: CGFloat = 0.0
    let curveLeadingOffset: CGFloat = 40.0
    let curveTrailingOffset: CGFloat = 0.0

    var startDate = String()
    var endDate = String()
    private var chartValues = [String: [CGPoint]]()
    private var actualValues = [String: [Double]]()

    private let gridLayer = CALayer()
    private let curveLayer = CALayer()
    private let gradientLayer = CAGradientLayer()
    private let pointLayer = CALayer()
    private let selectionLayer = CALayer()

    let fmt: NumberFormatter = {
        let n = NumberFormatter()
        n.usesGroupingSeparator = true
        n.numberStyle = .decimal
        n.locale = Locale(identifier: "sv_SE")
        n.maximumFractionDigits = 0
        return n
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        gradientLayer.colors = [gradientColors[0].cgColor, gradientColors[1].cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        layer.addSublayer(gradientLayer)
        layer.addSublayer(curveLayer)
        layer.addSublayer(gridLayer)
        layer.addSublayer(pointLayer)
        layer.addSublayer(selectionLayer)

        backgroundColor = chartBgColor

        let plotFrame = CGRect(x: 0, y: topSpace, width: frame.width, height: frame.height - topSpace - bottomSpace)
        gridLayer.frame = plotFrame
        curveLayer.frame = plotFrame
        gradientLayer.frame = plotFrame
        pointLayer.frame = plotFrame
        selectionLayer.frame = plotFrame
    }

    public func plot(dataEntries: [DataEntry], startDate: String, endDate: String) {
        clean()
        self.startDate = startDate
        self.endDate = endDate
        lineGap = (curveLayer.frame.size.width - (curveLeadingOffset + curveTrailingOffset)) / CGFloat(dataEntries.count - 1)

        chartMin = CGFloat(0)
        chartMax = calcChartMax(upperBound: dataEntries.max()!.upperBound)
        chartRange = chartMax - chartMin

        let (lowerBoundPoints, curvePoints, upperBoundPoints) = calcPoints(dataEntries: dataEntries)
        drawCurve(points: curvePoints, lineWidth: mainLineWidth, lineColor: defaultLineColor.cgColor)

        // shadeAreaUnderCurve(curvePoints: curvePoints)
        shadeBounds(upperBoundPoints: upperBoundPoints, lowerBoundPoints: lowerBoundPoints)
        // drawHorizontalLines(dataEntries: dataEntries)
        drawGrid(dataEntries: dataEntries)
    }

    private func calcChartMax(upperBound: Double) -> CGFloat {
        if upperBound < 100_000 {
            chartRes = CGFloat(500)
            return CGFloat(100_000)
        } else if upperBound < 1_000_000 {
            chartRes = CGFloat(500_000)
            return CGFloat(1_000_000)
        } else {
            chartRes = CGFloat(500_000)
            let x = ceil(log(upperBound / 1_000_000) / log(chartMaxGrowth))
            return CGFloat(1_000_000 * pow(chartMaxGrowth, x))
        }
    }

    private func createPath(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: points[0])
        for i in 1 ..< points.count {
            path.addLine(to: points[i])
        }
        return path
    }

    private func drawCurve(points: [CGPoint], lineWidth: CGFloat, lineColor: CGColor) {
        let path = createPath(points: points)
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = lineColor
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineWidth = lineWidth
        curveLayer.addSublayer(lineLayer)
    }

    public func markDate(date: String) {
        drawLabel(date: date)
        drawMarkerLine(date: date)
        drawPoint(date: date, layer: pointLayer)
    }

    private func selectDate(x: CGFloat) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY"

        var curveX = x - curveLeadingOffset

        if curveX < 0 {
            curveX = 0
        } else if curveX > curveLayer.frame.width - curveLeadingOffset - curveTrailingOffset {
            curveX = curveLayer.frame.width - curveLeadingOffset - curveTrailingOffset
        }

        let n = Int(round(curveX / lineGap))
        var date = Date()
        // var date = formatter.date(from: startDate)!
        date = Calendar.current.date(byAdding: .month, value: n, to: date)!
        var dateString = formatter.string(from: date)

        dateString = String(endDate.prefix(4) + dateString.suffix(4))

        clearSelection()
        drawAllPoints(date: dateString)
        if dateString == endDate {
            drawPoint(date: dateString, layer: selectionLayer)
        }
        showPopup(date: dateString)
    }

    private func drawAllPoints(date: String) {
        let sizes = [markerSize, markerSize, markerSize]

        var markers = [Marker]()
        for (i, point) in chartValues[date]!.enumerated() {
            let marker = Marker(strokeColor: markerStrokeColors[i], fillColor: markerFillColors[i], lineWidth: markerLineWidth)
            let xValue = point.x - sizes[i] / 2
            let yValue = point.y - sizes[i] / 2
            marker.frame = CGRect(x: xValue, y: yValue, width: sizes[i], height: sizes[i])
            switch i {
            case 0:
                marker.triangleDown()
            case 2:
                marker.triangleUp()
            default:
                marker.circle()
            }
            markers.append(marker)
        }

        for i in [0, 2, 1] {
            selectionLayer.addSublayer(markers[i])
        }
    }

    private func showPopup(date: String) {
        let valueList = [
            "\(fmt.string(from: NSNumber(value: Int(round(actualValues[date]![0]))))!) kr",
            "\(fmt.string(from: NSNumber(value: Int(round(actualValues[date]![1]))))!) kr",
            "\(fmt.string(from: NSNumber(value: Int(round(actualValues[date]![2]))))!) kr",
        ]

        let popupInitialWidth = selectionLayer.frame.width * 0.26
        let popupWidth = popupInitialWidth + CGFloat(max(valueList[2].count - 12, 0)) * popupInitialWidth * 0.065
        let popupHeight = selectionLayer.frame.height * 0.3

        let popupLayer = CAGradientLayer()
        popupLayer.frame = CGRect(x: curveLeadingOffset, y: 0, width: popupWidth, height: popupHeight)
        popupLayer.colors = [#colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 0).cgColor, #colorLiteral(red: 0.1176470588, green: 0.431372549, blue: 0.1960784314, alpha: 0.1040850507).cgColor]
        popupLayer.cornerRadius = 10
        popupLayer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        popupLayer.shadowColor = UIColor.black.cgColor
        popupLayer.shadowOpacity = 0.2
        popupLayer.shadowOffset = CGSize(width: 1, height: 1)
        popupLayer.shadowRadius = 1

        let paddingX = CGFloat(5)
        let paddingY = CGFloat(5)
        let dateHeight = (popupLayer.frame.height - paddingY * 2) * 0.3
        let valuesHeight = (popupLayer.frame.height - paddingY * 2) * 0.7

        let dateLayer = CATextLayer()
        dateLayer.frame = CGRect(x: paddingX, y: paddingY, width: popupLayer.frame.width - paddingX * 2, height: dateHeight)
        dateLayer.fontSize = dateHeight * 0.8
        dateLayer.alignmentMode = .left
        dateLayer.string = date
        dateLayer.truncationMode = .end
        dateLayer.backgroundColor = UIColor.clear.cgColor
        dateLayer.foregroundColor = dotBgColor.cgColor
        dateLayer.contentsScale = UIScreen.main.scale
        popupLayer.addSublayer(dateLayer)

        for (ind, i) in [1, 2, 0].enumerated() {
            let text = valueList[i]
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: paddingX, y: paddingY + dateHeight + (valuesHeight * 0.333) * CGFloat(ind), width: popupLayer.frame.width - paddingX * 2, height: valuesHeight * 0.333)
            textLayer.fontSize = valuesHeight * 0.333 * 0.8
            textLayer.alignmentMode = .right
            textLayer.string = text
            textLayer.truncationMode = .end
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.foregroundColor = dotBgColor.cgColor
            textLayer.contentsScale = UIScreen.main.scale
            popupLayer.addSublayer(textLayer)

            let markerSize = markerSize + 2
            let marker = Marker(strokeColor: markerStrokeColors[i], fillColor: markerFillColors[i], lineWidth: markerLineWidth)
            let xValue = paddingX
            let yValue = paddingY + dateHeight + (valuesHeight * 0.333) * CGFloat(ind) - markerSize / 2 + valuesHeight * 0.333 * 0.5
            marker.frame = CGRect(x: xValue, y: yValue, width: markerSize, height: markerSize)
            switch i {
            case 2:
                marker.triangleUp()
            case 0:
                marker.triangleDown()
            default:
                if date == endDate {
                    marker.fillColor = dotInnerColor.cgColor
                }
                marker.circle()
            }
            popupLayer.addSublayer(marker)
        }

        selectionLayer.addSublayer(popupLayer)
    }

    private func drawPoint(date: String, layer: CALayer) {
        if let point = chartValues[date]?[1] {
            let xValue = point.x - goalMarkerSize / 2
            let yValue = point.y - goalMarkerSize / 2
            let marker = Marker(strokeColor: dotBgColor.cgColor, fillColor: dotInnerColor.cgColor, lineWidth: goalMarkerLineWidth)
            marker.frame = CGRect(x: xValue, y: yValue, width: goalMarkerSize, height: goalMarkerSize)
            marker.circle()
            layer.addSublayer(marker)
        }
    }

    private func drawLabel(date: String) {
        if let point = chartValues[date]?[1] {
            let textLayer = CATextLayer()

            var xValue: CGFloat
            if point.x + labelWidth / 2 > frame.width {
                xValue = frame.width - labelWidth
            } else {
                xValue = point.x - labelWidth / 2
            }

            textLayer.frame = CGRect(x: xValue, y: pointLayer.frame.size.height + bottomSpace / 2 - 16, width: labelWidth, height: 16)
            textLayer.foregroundColor = gridColor.cgColor
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.alignmentMode = CATextLayerAlignmentMode.center
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
            textLayer.fontSize = 11
            textLayer.string = date
            pointLayer.addSublayer(textLayer)
        }
    }

    private func drawMarkerLine(date: String) {
        if let point = chartValues[date]?[1] {
            let endpoint = CGPoint(x: point.x, y: pointLayer.frame.height)
            let path = createPath(points: [point, endpoint])
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor = dotBgColor.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.lineWidth = 1
            pointLayer.addSublayer(lineLayer)
        }
    }

    private func calcPointsFromArray(values: [Double]) -> [CGPoint] {
        var result: [CGPoint] = []
        for i in 0 ..< values.count {
            let point = CGPoint(x: CGFloat(i) * lineGap + curveLeadingOffset,
                                y: curveLayer.frame.height * (1 - ((CGFloat(values[i]) - CGFloat(chartMin)) / chartRange)))
            result.append(point)
        }
        return result
    }

    private func calcPoints(dataEntries: [DataEntry]) -> ([CGPoint], [CGPoint], [CGPoint]) {
        var curvePoints: [CGPoint] = []
        var lowerBoundPoints: [CGPoint] = []
        var upperBoundPoints: [CGPoint] = []
        for i in 0 ..< dataEntries.count {
            let point = CGPoint(x: CGFloat(i) * lineGap + curveLeadingOffset,
                                y: curveLayer.frame.height * (1 - ((CGFloat(dataEntries[i].value) - CGFloat(chartMin)) / chartRange)))
            let lowerBoundPoint = CGPoint(x: CGFloat(i) * lineGap + curveLeadingOffset,
                                          y: curveLayer.frame.height * (1 - ((CGFloat(dataEntries[i].lowerBound) - CGFloat(chartMin)) / chartRange)))
            let upperBoundPoint = CGPoint(x: CGFloat(i) * lineGap + curveLeadingOffset,
                                          y: curveLayer.frame.height * (1 - ((CGFloat(dataEntries[i].upperBound) - CGFloat(chartMin)) / chartRange)))
            curvePoints.append(point)
            lowerBoundPoints.append(lowerBoundPoint)
            upperBoundPoints.append(upperBoundPoint)
            chartValues[dataEntries[i].date] = [lowerBoundPoint, point, upperBoundPoint]
            actualValues[dataEntries[i].date] = [dataEntries[i].lowerBound, dataEntries[i].value, dataEntries[i].upperBound]
        }
        return (lowerBoundPoints, curvePoints, upperBoundPoints)
    }

    private func shadeBounds(upperBoundPoints: [CGPoint], lowerBoundPoints: [CGPoint]) {
        let points = upperBoundPoints + lowerBoundPoints.reversed() + [upperBoundPoints[0]]
        maskGradientLayer(points: points)
    }

    private func shadeAreaUnderCurve(curvePoints: [CGPoint]) {
        let points = [CGPoint(x: curvePoints[0].x, y: gradientLayer.frame.height)]
            + curvePoints
            + [CGPoint(x: curvePoints[curvePoints.count - 1].x, y: gradientLayer.frame.height),
               CGPoint(x: curvePoints[0].x, y: gradientLayer.frame.height)]
        maskGradientLayer(points: points)
    }

    private func maskGradientLayer(points: [CGPoint]) {
        let path = createPath(points: points)

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.strokeColor = UIColor.clear.cgColor
        maskLayer.lineWidth = 0.0

        gradientLayer.mask = maskLayer
    }

    private func getGridLabel(val: Int) -> String {
        var label = String()
        let f = val / 1000
        if f >= 1000 {
            label = String(Double(val) / 1_000_000.0).replacingOccurrences(of: ".0", with: "") + "M"
        } else if f >= 1 {
            label = String(Double(val) / 1000.0).replacingOccurrences(of: ".0", with: "") + "K"
        } else {
            label = String(val)
        }
        return label
    }

    private func drawGrid(dataEntries _: [DataEntry]) {
//        let gridRatios = [0, 0.25, 0.5, 0.75, 1]
        let gridRatios = [0, 0.5, 1]
        for gr in gridRatios {
            let val = Int(((1 - CGFloat(gr)) * chartRange + chartMin) / chartRes) * Int(chartRes)
            let height = gridLayer.frame.height * (1 - ((CGFloat(val) - CGFloat(chartMin)) / chartRange))

            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: gridLayer.frame.size.width, y: height))

            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.strokeColor = gridColor.cgColor
            lineLayer.lineWidth = 0.5
            lineLayer.lineDashPattern = [4, 4]

            gridLayer.addSublayer(lineLayer)

            let text = getGridLabel(val: val)
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: 4, y: height, width: 50, height: 16)
            textLayer.foregroundColor = gridColor.cgColor
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
            textLayer.fontSize = 12
            textLayer.string = text

            gridLayer.addSublayer(textLayer)
        }
    }

    private func drawHorizontalLines(dataEntries: [DataEntry]) {
        var gridValues: [CGFloat]?
        if dataEntries.count < 4, dataEntries.count > 0 {
            gridValues = [0, 1]
        } else if dataEntries.count >= 4 {
//            gridValues = [0, 0.25, 0.5, 0.75, 1]
            gridValues = [0, 0.5, 1]
        }
        if let gridValues = gridValues {
            for value in gridValues {
                let height = value * gridLayer.frame.size.height

                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: gridLayer.frame.size.width, y: height))

                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = gridColor.cgColor
                lineLayer.lineWidth = 0.5
                if value > 0.0, value < 1.0 {
                    lineLayer.lineDashPattern = [4, 4]
                }
                lineLayer.lineDashPattern = [4, 4]

                gridLayer.addSublayer(lineLayer)

                var lineValue: Int = 0

                lineValue = Int((1 - value) * chartRange) + Int(chartMin)

                let textLayer = CATextLayer()
                textLayer.frame = CGRect(x: 4, y: height, width: 50, height: 16)
                textLayer.foregroundColor = gridColor.cgColor
                textLayer.backgroundColor = UIColor.clear.cgColor
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                textLayer.fontSize = 12
                textLayer.string = "\(lineValue)"

                gridLayer.addSublayer(textLayer)
            }
        }
    }

    private func clearSelection() {
        selectionLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }

    private func clean() {
        layer.sublayers?.forEach {
            if $0 is CATextLayer {
                $0.removeFromSuperlayer()
            }
        }
        gridLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        gradientLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        curveLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        pointLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        selectionLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            pointLayer.opacity = 0.4
            selectDate(x: position.x)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            selectDate(x: position.x)
        }
    }

    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        // Clean up
        clearSelection()
        pointLayer.opacity = 1.0
    }
}

// extension Dictionary {
//    public init(keys: [Key], values: [Value]) {
//        precondition(keys.count == values.count)
//
//        self.init()
//
//        for (index, key) in keys.enumerated() {
//            self[key] = values[index]
//        }
//    }
// }
