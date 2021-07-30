
let projectDir = "/Users/xinyi/projects/OnePlayer.iOS"
let ignoreFolders = [
    "src/OnePlayer.Example",
    "src/OnePlayerCore/Tests",
    "src/OnePlayerTelemetry/Tests",
    "src/OnePlayerSVE"
]

let analyzer = SwiftProjectAnalyzer(projectDirectory: projectDir, ignoreFolders: ignoreFolders)

do {
    try analyzer.start()
} catch {
    print(error)
}
