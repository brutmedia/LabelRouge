import UIKit
import WebKit

class LabelRouge: UILabel {
    var highlightColor: UIColor = .yellow
    var highlightInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)

    private let wrapper = LineWrapper()

    private var textAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize),
                NSAttributedString.Key.foregroundColor: textColor ?? .darkText]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        isOpaque = false
        backgroundColor = .clear
        clearsContextBeforeDrawing = true
    }

    private func wrappedText(for text: String, width: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: wrappedLines(for: text, width: width).joined(separator: "\n"), attributes: textAttributes)
    }
    private func wrappedLines(for text: String, width: CGFloat) -> [String] {
        let paddedWidth = max(width - highlightInsets.left - highlightInsets.right, 0)
        return wrapper.wrap(paragraph: text, to: paddedWidth, attributes: textAttributes)
    }

    override func drawText(in rect: CGRect) {
        guard let text = text, !text.isEmpty else { return }

        let context = UIGraphicsGetCurrentContext()

        for (index, line) in wrappedLines(for: text, width: rect.width).enumerated() {
            let textRect = line.boundingRect(with: CGSize(width: bounds.width, height: font.capHeight),
                                             options: [],
                                             attributes: textAttributes,
                                             context: nil)
            let lineRect = CGRect(origin: CGPoint(x: 0, y: font.lineHeight * CGFloat(index)),
                                  size: CGSize(width: textRect.width + highlightInsets.left + highlightInsets.right,
                                               height: textRect.height + highlightInsets.top + highlightInsets.bottom))

            context?.setFillColor(highlightColor.cgColor)
            context?.fill(lineRect)
        }

        let wrappedText = self.wrappedText(for: text, width: rect.width)
        wrappedText.draw(at: rect.inset(by: highlightInsets).origin)
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard let text = text, !text.isEmpty else { return .zero }

        let textSize = wrappedText(for: text, width: bounds.width).size()

        return CGRect(origin: bounds.origin, size: CGSize(width: textSize.width + highlightInsets.left + highlightInsets.right, height: textSize.height + highlightInsets.top + highlightInsets.bottom))
    }
}
