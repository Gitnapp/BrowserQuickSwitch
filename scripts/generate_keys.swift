#!/usr/bin/env swift
import Foundation
import CryptoKit

let privateKey = Curve25519.Signing.PrivateKey()
let seed = privateKey.rawRepresentation
let publicKeyBytes = privateKey.publicKey.rawRepresentation

// Sparkle format: seed (32 bytes) + public key (32 bytes) = 64 bytes
let sparklePrivateKey = seed + publicKeyBytes

print("=== Sparkle EdDSA Key Pair ===\n")
print("Private key (add to GitHub Secrets as SPARKLE_PRIVATE_KEY):")
print(sparklePrivateKey.base64EncodedString())
print("")
print("Public key (replace PLACEHOLDER_PUBLIC_KEY in Info.plist):")
print(publicKeyBytes.base64EncodedString())
print("")
print("Steps:")
print("1. Copy the public key into Info.plist -> SUPublicEDKey")
print("2. Go to GitHub repo -> Settings -> Secrets -> Actions")
print("3. Add secret SPARKLE_PRIVATE_KEY with the private key value")
