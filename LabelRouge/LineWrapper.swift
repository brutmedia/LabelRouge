import Foundation
import CoreGraphics

extension String {
    mutating func stripTrailingSpace() {
        guard let last = last else { return }

        if last.isWhitespace || last.isNewline {
            removeLast()
            stripTrailingSpace()
        }
    }
}

class LineWrapper {
    func wrap(paragraph: String, to width: CGFloat, attributes: [NSAttributedString.Key: Any]? = nil) -> [String] {
        let space: Character = " "
        let words = paragraph.split(separator: space).map { String($0) }

        let lines = createLines(with: words, width: width, attributes: attributes, separator: String(space))

        return lines
    }

    private func createLines(with items: [String], width: CGFloat, attributes: [NSAttributedString.Key: Any]?, separator: String) -> [String] {
        guard width > 0 else { return items }

        var lines: [String] = []
        var currentOffset: Int = 0

        while currentOffset < items.count {
            var line = ""
            var lineOffset = currentOffset

            while lineOffset < items.count {
                let item = items[lineOffset]
                let lineWithNewWord = line + item
                let lineWithNewWordSize = lineWithNewWord.size(withAttributes: attributes)

                if lineWithNewWordSize.width <= width {
                    line = lineWithNewWord + separator
                    lineOffset += 1

                    if lineOffset == items.count {
                        line.stripTrailingSpace()
                        lines.append(line)
                        currentOffset = lineOffset
                        break
                    }
                } else {
                    if lineWithNewWord == item {
                        let itemSize = item.size(withAttributes: attributes)
                        if itemSize.width > width || item.count <= 1 {
                            let letters: [String] = item.lazy.map { String($0) }
                            lines += createLines(with: letters, width: width, attributes: attributes, separator: "")
                            currentOffset = lineOffset + 1
                            break
                        }
                    } else {
                        line.stripTrailingSpace()
                        lines.append(line)
                        currentOffset = lineOffset
                        break
                    }
                }
            }
        }

        return lines
    }
}
