import SwiftSemantics

struct SPAClassContainer {
    let currentClass: Class
    let variables: [Variable]
    let functions: [Function]
}

extension SPAClassContainer {
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
}

extension SPAClassContainer: SPAGraphNodeConvertable {
    var id: String {
        self.currentClass.name
    }
}
