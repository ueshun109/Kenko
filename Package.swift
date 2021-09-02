// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Kenko",
  platforms: [
      .iOS(.v14), .watchOS(.v7)
    ],
  products: [
    .library(
      name: "Kenko",
      targets: ["Kenko"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "Kenko",
      dependencies: []),
    .testTarget(
      name: "KenkoTests",
      dependencies: ["Kenko"]),
  ]
)
