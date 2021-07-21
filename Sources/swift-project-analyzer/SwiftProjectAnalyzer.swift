import Foundation

final class SwiftProjectAnalyzer {
    private let projectDirectory: String
    private let ignoreFolders: [String]
    
    init(projectDirectory: String, ignoreFolders: [String]) {
        self.projectDirectory = projectDirectory
        self.ignoreFolders = ignoreFolders
    }
    
    func start() {
        for url in self.subPaths {
            print(url)
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
}
