import XCTest

class LineWrapperTests: XCTestCase {
    func testWrapLongParagraphWithVariousSizes() {
        let text = "Quand M. Bilbon Sacquet, de Cul-de-Sac, annonça qu'il donnerait à l'occasion de son undécante-unième anniversaire une réception d'une magnificence particulière, une grande excitation régna dans Hobbitebourg, et toute la ville en parla."

        var lines = LineWrapper().wrap(paragraph: text, to: 200)
        XCTAssertEqual(["Quand M. Bilbon Sacquet, de",
                        "Cul-de-Sac, annonça qu'il donnerait",
                        "à l'occasion de son",
                        "undécante-unième anniversaire une",
                        "réception d'une magnificence",
                        "particulière, une grande excitation",
                        "régna dans Hobbitebourg, et toute la",
                        "ville en parla."], lines)

        lines = LineWrapper().wrap(paragraph: text, to: 600)
        XCTAssertEqual(["Quand M. Bilbon Sacquet, de Cul-de-Sac, annonça qu'il donnerait à l'occasion de son undécante-unième",
                        "anniversaire une réception d'une magnificence particulière, une grande excitation régna dans Hobbitebourg, et",
                        "toute la ville en parla."], lines)

        lines = LineWrapper().wrap(paragraph: text, to: 100)
        XCTAssertEqual(["Quand M. Bilbon",
                        "Sacquet, de",
                        "Cul-de-Sac,",
                        "annonça qu'il",
                        "donnerait à",
                        "l'occasion de son",
                        "undécante-unième",
                        "anniversaire une",
                        "réception d'une",
                        "magnificence",
                        "particulière, une",
                        "grande excitation",
                        "régna dans",
                        "Hobbitebourg, et",
                        "toute la ville en",
                        "parla."], lines)
    }

    func testWrapTextWithVariousFontSizes() {
        let text = "For nothing is evil in the beginning. Even Sauron was not so."

        var lines = LineWrapper().wrap(paragraph: text, to: 300, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle)])
        XCTAssertEqual(["For nothing is evil in",
                        "the beginning. Even",
                        "Sauron was not so."], lines)

        lines = LineWrapper().wrap(paragraph: text, to: 300, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        XCTAssertEqual(["For nothing is evil in the",
                        "beginning. Even Sauron",
                        "was not so."], lines)

        lines = LineWrapper().wrap(paragraph: text, to: 300, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)])
        XCTAssertEqual(["For nothing is evil in the beginning.",
                        "Even Sauron was not so."], lines)

        lines = LineWrapper().wrap(paragraph: text, to: 300, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        XCTAssertEqual(["For nothing is evil in the beginning. Even Sauron was",
                        "not so."], lines)
    }

    func testWrapTextAndStripTrailingInvisibleCharacters() {
        let text = "Gilets jaunes : le nombre de radars vandalisés explose"

        var lines = LineWrapper().wrap(paragraph: text + "\t", to: 375, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        XCTAssertEqual(["Gilets jaunes : le nombre de",
                        "radars vandalisés explose"], lines)

        lines = LineWrapper().wrap(paragraph: text + "\n", to: 375, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        XCTAssertEqual(["Gilets jaunes : le nombre de",
                        "radars vandalisés explose"], lines)

        lines = LineWrapper().wrap(paragraph: text + "    ", to: 375, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        XCTAssertEqual(["Gilets jaunes : le nombre de",
                        "radars vandalisés explose"], lines)

        lines = LineWrapper().wrap(paragraph: text + " ", to: 375, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        XCTAssertEqual(["Gilets jaunes : le nombre de",
                        "radars vandalisés explose"], lines)
    }

}
