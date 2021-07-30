
let projectDir = "/Users/xinyi/projects/swift-syntax"
let ignoreFolders = [
    "Tests",
    "lit_tests"
]

let analyzer = SwiftProjectAnalyzer(projectDirectory: projectDir, ignoreFolders: ignoreFolders)

do {
    try analyzer.start()
} catch {
    print(error)
}
