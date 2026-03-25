#!/usr/bin/env swift
import Foundation
import CryptoKit

guard CommandLine.arguments.count == 3 else {
    fputs("Usage: swift sign_update.swift <private_key_base64> <file_path>\n", stderr)
    exit(1)
}

let privateKeyBase64 = CommandLine.arguments[1]
let filePath = CommandLine.arguments[2]

guard let keyData = Data(base64Encoded: privateKeyBase64) else {
    fputs("Error: Invalid base64 private key\n", stderr)
    exit(1)
}

// Sparkle private key: seed (32 bytes) + public (32 bytes) = 64 bytes
// CryptoKit needs just the seed (first 32 bytes)
let seed = keyData.prefix(32)
guard let privateKey = try? Curve25519.Signing.PrivateKey(rawRepresentation: seed) else {
    fputs("Error: Invalid Ed25519 key\n", stderr)
    exit(1)
}

let fileURL = URL(fileURLWithPath: filePath)
guard let fileData = try? Data(contentsOf: fileURL) else {
    fputs("Error: Cannot read file \(filePath)\n", stderr)
    exit(1)
}

guard let signature = try? privateKey.signature(for: fileData) else {
    fputs("Error: Signing failed\n", stderr)
    exit(1)
}

let length = fileData.count
print("edSignature=\(signature.base64EncodedString())")
print("length=\(length)")
