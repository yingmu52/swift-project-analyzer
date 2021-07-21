

let projectDir: String = ""
let ignoreFolders: [String] = [
]

let analyzer = SwiftProjectAnalyzer(projectDirectory: projectDir, ignoreFolders: ignoreFolders)

do {
    try analyzer.start()
} catch {
    print(error)
}
