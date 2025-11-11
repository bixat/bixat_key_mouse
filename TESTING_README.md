# Testing Guide - Bixat Key Mouse

## Quick Start

### 1. Run the Example App

```bash
cd example
flutter run
```

### 2. Navigate to Key Testing Tab

- Open the app
- Click on the **"Key Testing"** tab (6th tab)
- You'll see the automated key testing interface

### 3. Run Automated Tests

1. Click **"Start Testing All Keys"** button
2. Wait for the test to complete (~15-20 seconds)
3. Review the results:
   - **Summary**: Shows total, passed, and failed counts
   - **Failed Keys**: Expandable red section with details
   - **Passed Keys**: Expandable green section

### 4. Export Test Results

Click the **"Export Results to Console"** button to generate a detailed report in the console/terminal.

The exported log includes:
- Platform information (macOS, Windows, Linux)
- Timestamp
- Summary statistics
- Complete list of failed keys with:
  - Key name
  - Expected label
  - Detected label
  - Timestamp
- List of passed keys

### 5. Copy the Logs

**From Flutter Console:**
```bash
# The logs will appear in your terminal
# Select and copy the entire output between the separator lines
```

**Example Log Format:**
```
flutter: Bixat Key Mouse - Key Testing Results
Generated: 2025-11-11 22:06:03.857584
Platform: macos
================================================================================

Summary:
  Total Keys Tested: 111
  Passed: 20
  Failed: 91
  Success Rate: 18.02%

================================================================================

FAILED KEYS (91):
--------------------------------------------------------------------------------
Key: quote
  Expected Label: Quote
  Detected Label: Quote Single
  Timestamp: 2025-11-11 22:10:27.590519
...
```

## Reporting Issues

### When to Report

Report an issue if you find keys that:
- ✅ Are detected with **wrong labels** (e.g., "Quote" vs "Quote Single")
- ✅ Are detected as **completely different keys** (e.g., "A" detected as "B")
- ❌ **Don't report** Fn key issues (hardware limitation)

### How to Report

1. **Open a GitHub Issue**: [Create New Issue](https://github.com/your-repo/issues/new)

2. **Use This Template**:

```markdown
## Failed Key Test Report

**Platform**: [macOS / Windows / Linux]
**Flutter Version**: [Run `flutter --version`]
**Keyboard Type**: [e.g., MacBook Pro built-in, External USB keyboard]

### Failed Keys

[Paste the exported log here]

### Additional Context

- [ ] This happens with physical keyboard
- [ ] This happens with external keyboard
- [ ] Other relevant information
```

3. **Attach Full Logs**: Copy the entire exported console output



## Platform-Specific Notes

### macOS
- Full support for F13-F20
- Media keys work in real apps
- Fn key is hardware-only

### Windows
- F13-F20 may not be available on all keyboards
- Some keys depend on keyboard driver

### Linux
- Key availability depends on desktop environment
- Some keys may require additional configuration


