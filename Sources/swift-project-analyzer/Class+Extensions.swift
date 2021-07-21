import SwiftSemantics

extension Class {
    var isPublic: Bool {
        self.modifiers.first { $0.name == "public" } != nil
    }
}
