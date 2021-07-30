import SwiftSemantics

protocol SPAGraphNodeConvertable {
    var id: String { get }
    var variables: [Variable] { get }
}

extension SPAGraphNodeConvertable {
    var node: SPAGraphNode {
        let children = self.variables
            .compactMap { variable -> SPAGraphNode? in
                if let type = variable.typeAnnotation?.replacingOccurrences(of: "?", with: "") { // ? for optional type
                    return .init(id: type)
                }
                return nil
            }
        return .init(id: self.id, children: children)
    }
}
