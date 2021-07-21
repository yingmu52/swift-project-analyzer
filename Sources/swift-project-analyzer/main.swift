import SwiftSyntax
import SwiftSemantics
import Foundation

func parseFile(path: String) throws -> DeclarationCollector {
    let url = URL(fileURLWithPath: path)
    let source = try SyntaxParser.parse(url)

    let collector = DeclarationCollector()
    let tree = try SyntaxParser.parse(source: source.description)
    collector.walk(tree)

    return collector
}


let projectDir: String = ""
let ignoreFolders: [String] = [
]

let analyzer = SwiftProjectAnalyzer(projectDirectory: projectDir, ignoreFolders: ignoreFolders)
analyzer.start()
