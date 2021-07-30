import SwiftSemantics

struct SPAProtocolContainer {
    let currentProtocol: Protocol
    let variables: [Variable]
    let functions: [Function]
}

extension SPAProtocolContainer {
    var node: SPAGraphNode {
        .init(id: self.currentProtocol.name)
    }
}
