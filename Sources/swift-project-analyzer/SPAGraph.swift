
class SPAGraphNode {
    let name: String
    let label: String
    let id: String
    
    var children: [SPAGraphNode] = []
    
    init(name: String, label: String, id: String, children: [SPAGraphNode] = []) {
        self.name = name
        self.label = label
        self.id = id
        self.children = children
    }
    
    var outputNode: SPAOutputJson.Node {
        .init(name: self.name, label: self.label, id: self.id)
    }
    var outputLinks: [SPAOutputJson.Link] {
        self.children.map { childNode in
            .init(source: self.outputNode.id, target: childNode.outputNode.id)
        }
    }
}

class SPAGraph {
    private(set) var nodes: [SPAGraphNode] = []
    
    func insert(_ newNode: SPAGraphNode) {
        var stack = self.nodes
        var inserted = false
        
        while !stack.isEmpty {
            var aNode = stack.removeFirst()
            if aNode.id == newNode.id, aNode.children.isEmpty {
                aNode = newNode
                inserted = true
            }
            stack += aNode.children
        }
        
        if !inserted {
            self.nodes.append(newNode)
        }
    }
    
    var outputJson: SPAOutputJson {
        var nodes = [SPAOutputJson.Node]()
        var links = [SPAOutputJson.Link]()
        
        var stack = self.nodes
        while !stack.isEmpty {
            let first = stack.removeFirst()
            nodes.append(first.outputNode)
            links += first.outputLinks
        }
        
        // create source if needed
        
        var sourceSet = Set(nodes.map { $0.id })
        
        var filterLinks: [SPAOutputJson.Link] = []
        
        for link in links {
            if !sourceSet.contains(link.source) {
                nodes.append(.init(name: link.source, label: "Missing", id: link.source))
                sourceSet.insert(link.source)
            }

            if !sourceSet.contains(link.target) {
                nodes.append(.init(name: link.target, label: "Missing", id: link.target))
                sourceSet.insert(link.target)
            }
        }
        
        return SPAOutputJson(nodes: nodes, links: links)
    }
}
