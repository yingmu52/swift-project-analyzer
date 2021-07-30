import SwiftSemantics

protocol SPANamable {
    var name: String { get }
}

extension Structure: SPANamable {}
extension Class: SPANamable {}
extension Protocol: SPANamable {}
