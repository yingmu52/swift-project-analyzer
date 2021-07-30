import SwiftSemantics

struct SPAProtocolContainer {
    let currentProtocol: Protocol
    let variables: [Variable]
    let functions: [Function]
}

extension SPAProtocolContainer: SPAGraphNodeConvertable {
    var id: String {
        self.currentProtocol.name
    }
}
