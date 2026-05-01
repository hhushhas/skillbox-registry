import AppKit
import Foundation
import Vision

struct Candidate {
    let url: URL
    let proposedName: String
    let confidence: String
    let sample: String
}

let args = Array(CommandLine.arguments.dropFirst())
let fileManager = FileManager.default

var root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
var filterPrefix = ""
var applyChanges = false
var limit: Int? = nil

var index = 0
while index < args.count {
    switch args[index] {
    case "--root":
        if index + 1 < args.count {
            root = URL(fileURLWithPath: NSString(string: args[index + 1]).expandingTildeInPath)
            index += 1
        }
    case "--filter":
        if index + 1 < args.count {
            filterPrefix = args[index + 1]
            index += 1
        }
    case "--apply":
        applyChanges = true
    case "--limit":
        if index + 1 < args.count {
            limit = Int(args[index + 1])
            index += 1
        }
    default:
        break
    }
    index += 1
}

let stopWords: Set<String> = [
    "the", "and", "for", "with", "from", "your", "youll", "ready", "entering", "before", "into",
    "that", "this", "have", "has", "are", "was", "were", "not", "but", "all", "can", "cannot",
    "file", "edit", "view", "tabs", "bookmarks", "window", "help", "host", "call", "new", "chat",
    "history", "search", "settings", "general", "account", "privacy", "billing", "today", "yesterday",
    "open", "close", "download", "share", "link", "join", "meeting", "room", "http", "https", "www",
    "com", "org", "app", "page", "home", "menu", "more", "save", "copy", "cancel", "done", "back",
    "next", "yes", "no", "tap", "mode", "demo", "participant", "participants", "you", "main",
    "dashboard", "screen", "screenshot", "book", "free", "trial", "browser", "tools", "spaces",
    "platform", "profiles"
]

func isAlreadyRenamed(_ name: String) -> Bool {
    name.range(of: #"^\d{4}-\d{2}-\d{2}__"#, options: .regularExpression) != nil ||
    name.range(of: #"^\d{4}__"#, options: .regularExpression) != nil
}

func isTarget(_ name: String) -> Bool {
    let lower = name.lowercased()
    guard lower.hasSuffix(".png") || lower.hasSuffix(".jpg") || lower.hasSuffix(".jpeg") else { return false }
    if isAlreadyRenamed(name) { return false }
    return lower.hasPrefix("screenshot ") ||
        lower.hasPrefix("screen shot ") ||
        lower.hasPrefix("scr-") ||
        lower.hasPrefix("simulator screenshot ") ||
        lower.contains("screenshot")
}

func normalizedWords(_ text: String) -> [String] {
    let lower = text.lowercased()
    let clean = String(lower.unicodeScalars.map { CharacterSet.alphanumerics.contains($0) ? Character($0) : " " })
    let pieces = clean.split(separator: " ").map(String.init)
    var seen = Set<String>()
    var out: [String] = []
    for piece in pieces {
        if piece.count < 2 { continue }
        if piece.allSatisfy(\.isNumber) { continue }
        if stopWords.contains(piece) { continue }
        if seen.insert(piece).inserted {
            out.append(piece)
        }
    }
    return out
}

func ocrLines(for url: URL) -> [String] {
    guard
        let image = NSImage(contentsOf: url),
        let tiff = image.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiff),
        let cgImage = bitmap.cgImage
    else { return [] }

    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

    do {
        try handler.perform([request])
        return (request.results ?? []).prefix(12).compactMap { $0.topCandidates(1).first?.string }
    } catch {
        return []
    }
}

func datePart(from name: String) -> String {
    if let match = name.range(of: #"(20\d{2}-\d{2}-\d{2})"#, options: .regularExpression) {
        return String(name[match])
    }
    if let match = name.range(of: #"SCR-(20\d{2})(\d{2})(\d{2})"#, options: .regularExpression) {
        let raw = String(name[match]).replacingOccurrences(of: "SCR-", with: "")
        return "\(raw.prefix(4))-\(raw.dropFirst(4).prefix(2))-\(raw.suffix(2))"
    }
    return "undated"
}

func timePart(from name: String) -> String {
    if let match = name.range(of: #"at ([0-9]{1,2})[.\-:]([0-9]{2})[.\-:]([0-9]{2})"#, options: .regularExpression) {
        let raw = String(name[match]).replacingOccurrences(of: "at ", with: "")
        let parts = raw.split(whereSeparator: { ".-: ".contains($0) }).map(String.init)
        if parts.count == 3 {
            let hour = parts[0].count == 1 ? "0" + parts[0] : parts[0]
            return "\(hour)\(parts[1])\(parts[2])"
        }
    }
    return ""
}

func inferName(from name: String, lines: [String]) -> (String, String, String, String) {
    let joined = lines.joined(separator: " ")
    let lower = joined.lowercased()
    let tokens = normalizedWords(joined)

    func has(_ value: String) -> Bool { lower.contains(value) }
    func topic(_ count: Int = 4) -> String {
        Array(tokens.prefix(count)).joined(separator: "-")
    }

    if has("chalk") {
        if has("token exchange failed") { return ("chalk", "meeting", "host-token-exchange-failed", "medium") }
        if has("network request failed") { return ("chalk", "home", "new-meeting-network-request-failed", "medium") }
        if has("enter a code") { return ("chalk", "home", "new-meeting-enter-code", "medium") }
        if has("ready to join") { return ("chalk", "meeting", "join-screen", "medium") }
        return ("chalk", "app", topic(), "low")
    }
    if has("tuition highway") {
        if has("book a free demo") || has("book a free trial") {
            return ("tuition-highway", "homepage", "book-free-trial", "medium")
        }
        return ("tuition-highway", "site", topic(), "low")
    }
    if has("github") || has("contributions in the last year") {
        return ("github", "profile", "contributions", "medium")
    }
    if has("instagram") || (has("posts") && has("edit profile")) {
        return ("instagram", "profile", topic(), "medium")
    }
    if has("twilio dash") {
        return ("twilio-dash", "dashboard", topic(), "medium")
    }
    if has("twilio") || has("bundle name") || has("country") {
        return ("twilio", "bundle", topic(), "medium")
    }
    if has("ava") || has("good evening") || has("total calls") {
        return ("ava", "dashboard", topic(), "medium")
    }
    if has("q9labs") || has("qlabs") {
        return ("q9labs", "dashboard", topic(), "medium")
    }
    if has("onfido") || has("identity verification") {
        return ("onfido", "identity-verification", "thank-you", "medium")
    }
    if has("app store connect") || has("testflight") {
        return ("app-store-connect", "dashboard", topic(), "medium")
    }
    if has("xcode") || has("provisioning profile") {
        return ("xcode", "workspace", topic(), "medium")
    }
    if has("removebg") {
        return ("removebg", "preview", "image-cutout", "low")
    }
    if tokens.count >= 3 {
        return (tokens[0], tokens[1], Array(tokens.dropFirst(2).prefix(3)).joined(separator: "-"), "low")
    }
    return ("review", "review", "manual-review", "low")
}

func uniqueDestination(for name: String) -> URL {
    let ext = URL(fileURLWithPath: name).pathExtension
    let stem = URL(fileURLWithPath: name).deletingPathExtension().lastPathComponent
    var candidate = root.appendingPathComponent(name)
    var version = 2
    while fileManager.fileExists(atPath: candidate.path) {
        candidate = root.appendingPathComponent("\(stem)-v\(version).\(ext)")
        version += 1
    }
    return candidate
}

let urls = (try? fileManager.contentsOfDirectory(at: root, includingPropertiesForKeys: nil)) ?? []
var targets = urls
    .filter { isTarget($0.lastPathComponent) }
    .sorted { $0.lastPathComponent < $1.lastPathComponent }

if !filterPrefix.isEmpty {
    targets = targets.filter { $0.lastPathComponent.contains(filterPrefix) }
}
if let limit {
    targets = Array(targets.prefix(limit))
}

var results: [Candidate] = []

for url in targets {
    let name = url.lastPathComponent
    let date = datePart(from: name)
    let time = timePart(from: name)
    let lines = ocrLines(for: url)
    let sample = lines.prefix(4).joined(separator: " | ")
    let (project, surface, topic, confidence) = inferName(from: name, lines: lines)
    var proposed = date
    if !time.isEmpty {
        proposed += "__" + time
    }
    proposed += "__\(project)__\(surface)__\(topic).\(url.pathExtension.lowercased())"
    results.append(Candidate(url: url, proposedName: proposed, confidence: confidence, sample: sample))
}

for item in results {
    if applyChanges {
        let destination = uniqueDestination(for: item.proposedName)
        do {
            try fileManager.moveItem(at: item.url, to: destination)
            print("RENAMED\t\(item.url.lastPathComponent)\t\(destination.lastPathComponent)\t\(item.confidence)")
        } catch {
            print("FAILED\t\(item.url.lastPathComponent)\t\(error.localizedDescription)")
        }
    } else {
        print("\(item.confidence)\t\(item.url.lastPathComponent)\t\(item.proposedName)\t\(item.sample)")
    }
}
