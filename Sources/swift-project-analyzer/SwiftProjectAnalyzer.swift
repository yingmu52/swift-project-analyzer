import Foundation
import SwiftSyntax
import SwiftSemantics
import struct SwiftSemantics.Protocol

final class SwiftProjectAnalyzer {
    private let projectDirectory: String
    private let ignoreFolders: [String]
    private var visitorWrappers = Set<SPASyntaxVisitorWrapper>()
    private let graph = SPAGraph()
    
    init(projectDirectory: String, ignoreFolders: [String]) {
        self.projectDirectory = projectDirectory
        self.ignoreFolders = ignoreFolders
    }
    
    func start() throws {
        for url in self.subPaths {
            let visitor = try parseFile(path: self.getAbsolutePath(url))
            let wrapper = SPASyntaxVisitorWrapper(url: url, visitor: visitor)
            self.visitorWrappers.insert(wrapper)
        }
        
        let outputResult = try JSONEncoder().encode(self.graph.outputJson)
        if let consoleOut = String(data: outputResult, encoding: .utf8) {
            print(consoleOut) ///  this works with `swift run > web/graph.json`
        }
    }
}

private extension SwiftProjectAnalyzer {
    var subPaths: [String] {
        guard let urls = FileManager.default.subpaths(atPath: self.projectDirectory) else {
            return []
        }
        return urls
            .filter { isValidPath($0) }
            .sorted(by: depthOfDirectory)
    }
    
    func isValidPath(_ path: String) -> Bool {
        for ignoreFolder in self.ignoreFolders where path.hasPrefix(ignoreFolder) {
            return false
        }
        return path.hasSuffix(".swift")
    }
    
    func depthOfDirectory(lhs: String, rhs: String) -> Bool {
        lhs.components(separatedBy: "/").count < rhs.components(separatedBy: "/").count
    }
    
    func getAbsolutePath(_ path: String) -> String {
        "\(self.projectDirectory)/\(path)"
    }
    
    func parseFile(path: String) throws -> SPASyntaxVisitor {
        let url = URL(fileURLWithPath: path)
        let source = try SyntaxParser.parse(url)
        let visitor = SPASyntaxVisitor()
        visitor.delegate = self
        let tree = try SyntaxParser.parse(source: source.description)
        visitor.walk(tree)
        return visitor
    }
}

extension SwiftProjectAnalyzer: SPASyntaxVisitorDelegate {
    func visitor(_ visitor: SPASyntaxVisitor, didVisit aClass: Class, classContainer: SPAClassContainer) {
        self.graph.insert(classContainer.node)
    }
    
    func visitor(_ visitor: SPASyntaxVisitor, didVisit aProtocol: Protocol, protocolContainer: SPAProtocolContainer) {
        self.graph.insert(protocolContainer.node)
    }
}
