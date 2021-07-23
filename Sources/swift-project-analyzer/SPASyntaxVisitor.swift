import SwiftSyntax
import Foundation
import SwiftSemantics
import struct SwiftSemantics.Protocol

protocol SPASyntaxVisitorDelegate: AnyObject {
    func visitor(_ visitor: SPASyntaxVisitor, didVisit aClass: Class, cleanupContainer: SPASyntaxVisitor.SPACleanupContainer)
}

final class SPASyntaxVisitor: SyntaxVisitor {
    var classes: [Class] = []
    var variables: [Variable] = []
    var protocols: [Protocol] = []
    var structures: [Structure] = []
    var enumerations: [Enumeration] = []
    var enumerationCases: [Enumeration.Case] = []
    var deinitializers: [Deinitializer] = []
    var typealiases: [Typealias] = []
    var extensions: [Extension] = []
    var functions: [Function] = []
    var conditionalCompilationBlocks: [ConditionalCompilationBlock] = []
    var imports: [Import] = []
    var initializers: [Initializer] = []
    
    weak var delegate: SPASyntaxVisitorDelegate?
    
    struct SPACleanupContainer {
        let currentClass: Class
        let variables: [Variable]
        let functions: [Function]
    }
    
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        self.variables.append(contentsOf: Variable.variables(from: node))
        return .skipChildren
    }
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        self.classes.append(Class(node))
        return .visitChildren
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        self.functions.append(Function(node))
        return .skipChildren
    }
    
    override func visitPost(_ node: ClassDeclSyntax) {
        let currentClass = Class(node)
        let container = SPACleanupContainer(currentClass: currentClass,
                                            variables: self.variables,
                                            functions: self.functions)
        self.delegate?.visitor(self, didVisit: currentClass, cleanupContainer: container)
        self.variables.removeAll()
        self.functions.removeAll()
    }
}

extension SPASyntaxVisitor.SPACleanupContainer {
    func prettyPrint(match className: String? = nil) {
        if let className = className, self.currentClass.name != className {
            return
        }
        
        print("current class: \(self.currentClass.name)")
        print("variables: ")
        self.variables.forEach { variable in
            print("name: \(variable.name) | type: \(variable.typeAnnotation ?? "Unknown")")
        }
        print("functions: ")
        for f in self.functions {
            print(f.identifier)
        }
        print("-----\n")
    }
    
    var uxfElement: String {
        var tags = [
            "<element>",
            "<id>UMLClass</id>",
//            "<coordinates><x>100</x><y>100</y><w>500</w><h>500</h></coordinates>",
            "<panel_attributes>",
            "\(self.currentClass.name)",
            "--",
            "\(self.variables.map { "\($0.uxfVisibility) \($0.name): \($0.typeAnnotation ?? "Unknown")" }.joined(separator: "\n"))",
            "--",
            "\(self.functions.map { "\($0.uxfVisibility) \($0.identifier)" }.joined(separator: "\n"))",
            "</panel_attributes>",
            "<additional_attributes></additional_attributes>",
            "</element>"
        ]
        
        var width = 0
        for tag in tags {
            width = max(width, tag.count)
        }
        tags.insert("<coordinates><x>100</x><y>100</y><w>\(width + 50)</w><h>\(tags.count * 30 + 50)</h></coordinates>", at: 2 )
        return tags.joined(separator: "\n")
    }
}
