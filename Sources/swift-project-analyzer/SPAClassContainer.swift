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

extension SPAClassContainer {
    var node: SPAGraphNode {
        let children = self.variables
            .compactMap { variable -> SPAGraphNode? in
                if let type = variable.typeAnnotation?.replacingOccurrences(of: "?", with: "") { // ? for optional type
                    return SPAGraphNode(name: type)
                }
                return nil
            }
        return SPAGraphNode(name: self.currentClass.name, children: children)
    }
}
