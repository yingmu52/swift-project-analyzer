import SwiftSemantics

struct SPAProtocolContainer {
    let currentProtocol: Protocol
    let variables: [Variable]
    let functions: [Function]
}

extension SPAProtocolContainer {
    var node: SPAGraphNode {
        .init(name: self.currentProtocol.name,
              label: self.currentProtocol.name,
              id: self.currentProtocol.name)
    }
}
