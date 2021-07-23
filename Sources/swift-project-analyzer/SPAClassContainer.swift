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
