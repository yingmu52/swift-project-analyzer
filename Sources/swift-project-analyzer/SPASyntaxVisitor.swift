import SwiftSyntax
import Foundation
import SwiftSemantics
import struct SwiftSemantics.Protocol

protocol SPASyntaxVisitorDelegate: AnyObject {
    func visitor(_ visitor: SPASyntaxVisitor, didVisit aClass: Class, cleanupContainer: SPAClassContainer)
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
        let container = SPAClassContainer(currentClass: currentClass,
                                            variables: self.variables,
                                            functions: self.functions)
        self.delegate?.visitor(self, didVisit: currentClass, cleanupContainer: container)
        self.variables.removeAll()
        self.functions.removeAll()
    }
}

