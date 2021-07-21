import Foundation
import SwiftSyntax
import SwiftSemantics

final class SwiftProjectAnalyzer {
    private let projectDirectory: String
    private let ignoreFolders: [String]
    
    init(projectDirectory: String, ignoreFolders: [String]) {
        self.projectDirectory = projectDirectory
        self.ignoreFolders = ignoreFolders
    }
    
    func start() {
        for url in self.subPaths {
            do {
                let collector = try parseFile(path: self.getAbsolutePath(url))
                for v in collector.variables {
                    print(v)
                }
            } catch {
                print("fail parsing \(url)", error)
            }
        }
    }
}

extension SwiftProjectAnalyzer {
    func parseFile(path: String) throws -> DeclarationCollector {
        let url = URL(fileURLWithPath: path)
        let source = try SyntaxParser.parse(url)
        
        let collector = DeclarationCollector()
        let tree = try SyntaxParser.parse(source: source.description)
        collector.walk(tree)
        
        return collector
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
}
