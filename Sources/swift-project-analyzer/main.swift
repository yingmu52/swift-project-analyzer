

let projectDir: String = ""
let ignoreFolders: [String] = [
]

let analyzer = SwiftProjectAnalyzer(projectDirectory: projectDir, ignoreFolders: ignoreFolders)
analyzer.start()
