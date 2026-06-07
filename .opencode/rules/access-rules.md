---
trigger: always_on
---

# Antigravity Agent Access Control Rules

version: 1.0

# Define the scope of file access

scope:
  include:
    - "lib/**"           # Your main Flutter/Dart source code
    - "pubspec.yaml"     # Project dependencies and metadata
    - "analysis_options.yaml" # Linting rules
    - "test/**"          # Unit and widget tests
    - "assets/**"        # Relevant project assets (images, icons)
    - "README.md"        # Project documentation

  exclude:
    # Package Manager Directories (Credit intensive)
    - "**/node_modules/**"
    - "**/vendor/**"
    - "**/android/vendor/**"
    - ".dart_tool/**"
    - ".packages"
    - "pubspec.lock"     # Optional: Exclude if you don't need dependency version audits

    # Build and Temporary Files
    - "build/**"
    - "**/.g.dart"       # Generated code (Free up credits by ignoring boilerplate)
    - "**/*.freezed.dart"
    - "**/*.template.dart"
    - "ios/.symlinks/**"
    - "ios/Pods/**"

    # IDE and Local Configs
    - ".idea/**"
    - ".vscode/**"
    - "*.iml"
    - ".env*"           # Protect sensitive keys

# Interaction Constraints

constraints:

- "The agent must prioritize 'lib/' for any logic-based inquiries."
- "Do not perform deep scans of the 'android/' or 'ios/' directories unless specifically asked for native bridge troubleshooting."
- "Contextual analysis should ignore styling boilerplate unless it directly impacts logic."
