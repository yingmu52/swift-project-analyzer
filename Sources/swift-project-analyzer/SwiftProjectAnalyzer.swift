import Foundation
import SwiftSyntax
import SwiftSemantics

final class SwiftProjectAnalyzer {
    private let projectDirectory: String
    private let ignoreFolders: [String]
    private var collectorWrappers = Set<DeclarationCollectorWrapper>()
    
    init(projectDirectory: String, ignoreFolders: [String]) {
        self.projectDirectory = projectDirectory
        self.ignoreFolders = ignoreFolders
    }
    
    func start() throws {
        for url in self.subPaths {
            let collector = try parseFile(path: self.getAbsolutePath(url))
            let collectorWrapper = DeclarationCollectorWrapper(url: url, collector: collector)
            self.collectorWrappers.insert(collectorWrapper)
        }
        
        /*
         print(allClasses.map { $0.name })
         print(allEnums.map { $0.name })
         print(allStructs.map { $0.name })
         print(allProtocolNames)
        */
//        print(entries)
        entries.forEach { print($0) }
    }
}

extension SwiftProjectAnalyzer {
    
    var entries: [String] {
        var indegreeMap = [String: Int]()
        for aClass in self.allClasses {
            indegreeMap[aClass.name] = 0
        }
        for aStruct in self.allStructs {
            indegreeMap[aStruct.name] = 0
        }
        
        for aEnum in self.allEnums {
            indegreeMap[aEnum.name] = 0
        }
        

        // check class, struct, enum,
        for wrapper in self.collectorWrappers {
            for variable in wrapper.collector.variables {
                if var annotation = variable.typeAnnotation {
                    if annotation.hasSuffix("?") {
                        annotation.removeLast()
                    }
                    indegreeMap[annotation, default: -1] += 1
                }
            }
        }
        
        var res = [String]()
        for (k, v) in indegreeMap where v == 0 {
//            print(k,v)
            res.append(k)
        }
        return res
    }

    var allClasses: [Class] {
        self.collectorWrappers
            .filter { !$0.collector.classes.isEmpty }
            .flatMap { $0.collector.classes }
    }
    
    var allProtocolNames: [String] { // can't use [Protocol] or [SwiftSemantics.Protocol] :(
        self.collectorWrappers
            .filter { !$0.collector.protocols.isEmpty }
            .flatMap { $0.collector.protocols }
            .map { $0.name }
    }
    
    var allStructs: [Structure] {
        self.collectorWrappers
            .filter { !$0.collector.structures.isEmpty }
            .flatMap { $0.collector.structures }
    }
    
    var allEnums: [Enumeration] {
        self.collectorWrappers
            .filter { !$0.collector.enumerations.isEmpty }
            .flatMap { $0.collector.enumerations }
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
    
    func parseFile(path: String) throws -> DeclarationCollector {
        let url = URL(fileURLWithPath: path)
        let source = try SyntaxParser.parse(url)
        
        let collector = DeclarationCollector()
        let tree = try SyntaxParser.parse(source: source.description)
        collector.walk(tree)
        
        return collector
    }
}
