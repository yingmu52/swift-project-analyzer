import SwiftSemantics

protocol SPATypeContainer: SPAGraphNodeConvertable {
    associatedtype T
    var currentType: T { get }
    var variables: [Variable] { get }
    var functions: [Function] { get }
}

extension SPATypeContainer where Self.T: SPANamable {
    var id: String { self.currentType.name }
    
    func prettyPrint(match className: String? = nil) {
        if let className = className, self.currentType.name != className {
            return
        }
        
        print("current \(type(of: self.currentType)): \(self.currentType.name)")
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
}
