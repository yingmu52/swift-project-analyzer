import Foundation
import SwiftSyntax
import SwiftSemantics
import struct SwiftSemantics.Protocol

final class SwiftProjectAnalyzer {
    private let projectDirectory: String
    private let ignoreFolders: [String]
    private var visitorWrappers = Set<SPASyntaxVisitorWrapper>()
    
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
        /*
         print(allClasses.map { $0.name })
         print(allEnums.map { $0.name })
         print(allStructs.map { $0.name })
         print(allProtocolNames)
         print(allProtocols.map { $0.name })
         
         */
    }
}

extension SwiftProjectAnalyzer {
    
    var entries: [String] {
        var indegreeMap = [String: Int]()
        self.allClasses.forEach { indegreeMap[$0.name] = 0 }
        self.allStructs.forEach { indegreeMap[$0.name] = 0 }
        self.allEnums.forEach { indegreeMap[$0.name] = 0 }
        self.typealiases.forEach { indegreeMap[$0.name] = 0 }
        self.allProtocols.forEach { indegreeMap[$0.name] = 0 }
        
        // check class, struct, enum,
        for wrapper in self.visitorWrappers {
            for variable in wrapper.visitor.variables {
                if let annotation = variable.typeAnnotation {
                    var notFound = true
                    
                    // [OPMediaItem] contains OPMediaItem -> +1
                    for (existingType, indegree) in indegreeMap where annotation.contains(existingType) {
                        indegreeMap[existingType] = indegree + 1
                        notFound = false
                    }
                    
                    if notFound {
                        print("no indegree of \(annotation) is initiated")
                    }
                }
            }
        }
        
        var declarationsWithZeroIndegree = [String]()
        for (type, indegree) in indegreeMap where indegree == 0 {
            declarationsWithZeroIndegree.append(type)
        }
        return declarationsWithZeroIndegree
    }
    
    var allClasses: [Class] {
        self.visitorWrappers
            .filter { !$0.visitor.classes.isEmpty }
            .flatMap { $0.visitor.classes }
    }
    
    var allProtocols: [Protocol] {
        self.visitorWrappers
            .filter { !$0.visitor.protocols.isEmpty }
            .flatMap { $0.visitor.protocols }
    }
    
    var allStructs: [Structure] {
        self.visitorWrappers
            .filter { !$0.visitor.structures.isEmpty }
            .flatMap { $0.visitor.structures }
    }
    
    var allEnums: [Enumeration] {
        self.visitorWrappers
            .filter { !$0.visitor.enumerations.isEmpty }
            .flatMap { $0.visitor.enumerations }
    }
    
    var typealiases: [Typealias] {
        self.visitorWrappers
            .filter { !$0.visitor.typealiases.isEmpty }
            .flatMap { $0.visitor.typealiases }
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
    func visitor(_ visitor: SPASyntaxVisitor, didVisit aClass: Class, cleanupContainer: SPASyntaxVisitor.SPACleanupContainer) {
        cleanupContainer.prettyPrint()
    }
}
