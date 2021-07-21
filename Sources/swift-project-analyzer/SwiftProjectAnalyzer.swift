import Foundation

final class SwiftProjectAnalyzer {
    private let projectDirectory: String
    private let ignoreFolders: [String]
    
    init(projectDirectory: String, ignoreFolders: [String]) {
        self.projectDirectory = projectDirectory
        self.ignoreFolders = ignoreFolders
    }
    
    func start() {
        for url in self.subPaths where url.hasSuffix(".swift") {
            // skip ignore folders
            var shouldIgnoreUrl = false
            for folder in self.ignoreFolders where url.hasPrefix(folder) {
                shouldIgnoreUrl = true
                break
            }
            if shouldIgnoreUrl {
                continue
            }
            
            //
            print(url)
        }
    }
    
    private var subPaths: [String] {
        guard let urls = FileManager.default.subpaths(atPath: self.projectDirectory) else {
            return []
        }
        return urls.sorted(by: { self.depth(of: $0) < self.depth(of: $1) })
    }
    
    private func depth(of directory: String) -> Int {
        directory.components(separatedBy: "/").count
    }
}

