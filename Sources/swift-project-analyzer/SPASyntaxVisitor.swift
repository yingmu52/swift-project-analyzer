import SwiftSyntax
import Foundation
import SwiftSemantics
import struct SwiftSemantics.Protocol

protocol SPASyntaxVisitorDelegate: AnyObject {
    func visitor<T: SPATypeContainer>(_ visitor: SPASyntaxVisitor, didCollect typeContainer: T)
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
    
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        self.structures.append(Structure(node))
        return .visitChildren
    }
    
    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        protocols.append(Protocol(node))
        return .visitChildren
    }

    
    // MARK: - Post Visit
    
    override func visitPost(_ node: StructDeclSyntax) {
        let currentStruct = Structure(node)
        let container = SPAStructContainer(currentType: currentStruct,
                                           variables: self.variables,
                                           functions: self.functions)
        self.delegate?.visitor(self, didCollect: container)
        self.clear()
    }
    
    override func visitPost(_ node: ClassDeclSyntax) {
        let currentClass = Class(node)
        let container = SPAClassContainer(currentType: currentClass,
                                            variables: self.variables,
                                            functions: self.functions)
        self.delegate?.visitor(self, didCollect: container)
        self.clear()
    }
    
    override func visitPost(_ node: ProtocolDeclSyntax) {
        let currentProtocol = Protocol(node)
        let container = SPAProtocolContainer(currentType: currentProtocol,
                                             variables: self.variables,
                                             functions: self.functions)
        self.delegate?.visitor(self, didCollect: container)
        self.clear()
    }
}

private extension SPASyntaxVisitor {
    func clear() {
        self.classes.removeAll()
        self.protocols.removeAll()
        self.structures.removeAll()
        self.variables.removeAll()
        self.functions.removeAll()
    }
}
