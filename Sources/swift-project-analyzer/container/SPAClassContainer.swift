import SwiftSemantics

struct SPAClassContainer: SPATypeContainer {
    let currentType: Class
    let variables: [Variable]
    let functions: [Function]
}
