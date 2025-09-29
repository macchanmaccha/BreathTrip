# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MeditationJourney is a Swift iOS application that enables users to meditate while virtually traveling the world. The app follows MVVM architecture and uses SwiftUI for the user interface.

## Development Commands

**Building and Running:**
- Open `MeditationJourney.xcodeproj` in Xcode
- Build: `⌘+B` or Product → Build
- Run: `⌘+R` or Product → Run
- Clean Build Folder: `⌘+Shift+K`

**Build Configuration:**
- iOS Deployment Target: 17.4+
- Swift Version: 5.0
- Bundle Identifier: JankenJanken.MeditationJourney
- Architecture: Universal (iPhone/iPad support)
- SwiftUI Previews: Enabled

**IDE Support:**
- `buildServer.json` configured for xcode-build-server (⚠️ workspace path needs updating for your environment)
- Enables Swift development in VS Code and other LSP-compatible editors
- Workspace: `MeditationJourney.xcodeproj/project.xcworkspace`

**Testing:**
- No unit test targets currently configured
- No UI test infrastructure present
- Manual testing required for all features

**Code Quality Tools:**
- **SwiftLint**: Style enforcement via `.swiftlint.yml` (auto-runs during build)
  - Custom rules: Line length disabled, single-character identifiers allowed
  - Install: `brew install swiftlint`
- **SwiftFormat**: Code formatting via `.swiftformat`
  - 4-space indentation, 120-character line limit
  - Install: `brew install swiftformat`

**VS Code Development:**
- Complete workspace configuration in `.vscode/` directory
- LLDB debugging for iOS Simulator (iPhone 15, iOS 17.4)
- Build tasks: `build`, `build-simple`, `clean`
- Usage: `Cmd+Shift+P` → "Tasks: Run Task" → "build"

## Architecture Overview

### MVVM Pattern (In Progress)
**⚠️ Currently transitioning to complete MVVM implementation**

The project is being refactored to implement proper Model-View-ViewModel architecture with clear separation:

- **Models** (`Model/`): Data structures and business logic
  - `MeditationInfo` - Core meditation session data structure
  - `SoundModel` - 36 world sounds organized by 6 continents
  - `ContinentModel` - Geographic organization of sounds
  - `SpotDataModel` - Map location data for meditation spots
  - `UserDefaultsKey` - Centralized UserDefaults management

- **Views** (`View/`): SwiftUI interface components organized by feature
  - `HomeView/` - Main app screens (Calendar, Settings, Map, etc.)
  - `PlayingView/` - Active meditation/listening sessions
  - `HowToView/` - Educational/instructional content
  - `SelectContinentAndMusicView/` - Sound selection interfaces

- **ViewModels** (`ViewModel/`): State management and business logic
  - `SetViewModel` - Base class for common sound/time settings
  - `MeditatingSetViewModel` - Meditation timer state machine
  - `ListeningSetViewModel` - Audio playback controls
  - `CalendarViewModel` - Calendar display and record management
  - `SpotListViewModel` - Map data and achievement calculations

### MVVM Refactoring Guidelines

**When implementing MVVM for new views:**
1. **Separate Concerns**: Extract business logic from Views into ViewModels
2. **Use @Published Properties**: Enable reactive UI updates
3. **Follow SetViewModel Pattern**: Inherit from base ViewModel when appropriate
4. **Repository Pattern**: Replace direct UserDefaults access with data services
5. **State Management**: Centralize state in ViewModels, not in Views

**MVVM Compliance Checklist:**
- ✅ Views only contain UI declaration and user interaction handling
- ✅ ViewModels contain all business logic and state management
- ✅ Models represent pure data structures without UI dependencies
- ✅ Data persistence handled through ViewModels or repositories
- ✅ No direct View-to-Model communication

### Key Architecture Decisions

1. **Geographic Sound System**: Sounds categorized by continents (Europe, Asia, Africa, Oceania, North/South America) with 6 sounds each
2. **Dual Timer Architecture**: Separate preparation and meditation timers with comprehensive state management
3. **Achievement-Based Map System**: Progress tracking with 60-minute meditation thresholds for location unlocking
4. **Color-Coded Calendar**: Three-tier visual system for meditation time representation

### Data Flow (Target MVVM Pattern)
1. User interaction → View
2. View calls ViewModel methods
3. ViewModel updates `@Published` properties
4. ViewModel handles data persistence via repositories
5. SwiftUI automatically refreshes UI
6. Settings persisted via UserDefaults through ViewModels

## Core Features

**Meditation Timer System:**
- State machine with preStart, start, pause, end states
- Configurable meditation duration (5, 10, 15, 30 minutes)
- Audio playback with world sound selection

**Navigation Structure:**
- TabView-based 5-tab bottom navigation (TabSetView.swift)
- Default selection: Tab 1 (Meditation) - MeditationSetView
- Tab 2: 音をきく (Listen) - ListeningSetView
- Tab 3: カレンダー (Calendar) - CalendarView  
- Tab 4: 地図 (Map) - MapView
- Tab 5: 瞑想とは (About) - ExplanationView

**Calendar Progress Tracking:**
- Visual meditation history with color coding
- Integration with meditation records
- Monthly/weekly view navigation

**World Map Integration:**
- Interactive map with meditation spot locations
- Achievement-based location unlocking
- Coordinates stored in SpotDataModel

## Persistence Layer

**Current Implementation:**
- UserDefaults for user preferences and settings
- Sample data in ViewModels for development
- Core Data infrastructure prepared but minimally used

**Core Data Setup:**
- `Persistence.swift` - Basic PersistenceController
- `MeditationJourney.xcdatamodeld` - Core Data model (template Item entity)

## Utility Extensions

**Date+Extension.swift:**
- Calendar calculations: `startOfMonth`, `daysInMonth`, `weeksInMonth`
- Date component extraction: `year`, `month`, `day`, `weekday`
- **Note:** Uses `fatalError()` for error handling (needs production-safe alternatives)

**Int+Extension.swift:**
- `formattedTime()` - Converts seconds to MM:SS format for timer displays
- Returns empty string for 0 values

**Color+Extension (MeditationTimeExtension.swift):**
- `backgroundStyle(for meditationTime: Int)` - Returns meditation time-based colors:
  - 1-20 minutes: `firstStageBlue`
  - 21-40 minutes: `secondStageBlue`  
  - 41-60 minutes: `thirdStageBlue`
  - 0 minutes: `Color.clear`

## File Structure

```
MeditationJourney/
├── Model/              # Data structures
├── View/               # SwiftUI views organized by feature
├── ViewModel/          # State management
├── Extensions/         # Utility extensions (Date, Int, Color)
├── Assets.xcassets/    # Colors, images, app icons
├── MeditationJourneyApp.swift    # App entry point
└── Persistence.swift   # Core Data setup
```

## Assets and Resources

**Color System:**
- Semantic color names in Assets.xcassets: `backgroundNavy`, `firstStageBlue`, `secondStageBlue`, `thirdStageBlue`
- Calendar colors: `DateInTodayLime` for current date highlighting
- UI colors: `accentGray`, `keyWhite` for interface elements

**Audio System:**
- 36 world sounds referenced by Japanese display names in SoundModel enum
- Sound categories: 6 sounds each for Europe, Oceania, Asia, Africa, North America, South America
- Audio files loaded externally (not found in app bundle)

## Code Conventions

- SwiftUI view files end with `View.swift`
- ViewModels use `@Published` for reactive properties
- Extensions organized by type in dedicated files
- Colors defined in Assets.xcassets with semantic names
- Image assets organized by feature/usage
- UI text in Japanese throughout the application
- File headers with project name, creator, and creation date

## ViewModel Patterns

**Inheritance Hierarchy:**
- `SetViewModel` - Base class with UserDefaults persistence and sound/time management
  - Manages `@Published` properties for sound selection and timer durations
  - Handles UserDefaults loading/saving for user preferences
  - Default sound fallback: `.europa1`
  - Methods designed for override by subclasses

**State Management:**
- UserDefaults integration for persistence
- `@Published` properties for reactive UI updates
- Base class provides template methods for sound/time configuration

**Data Persistence Strategy:**
- UserDefaults keys centralized in `UserDefaultsKey` enum
- Sound preferences: `meditationSoundName`, `listeningSoundName`
- Timer settings: `meditationMinutes`, `listeningMinutes`
- Meditation records: `meditationRecords` (key defined but not used)

## Development Notes

**Current State:**
- ViewModels contain sample data for development/testing
- Core Data infrastructure prepared but minimally used
- Achievement system uses hardcoded 60-minute thresholds
- All 36 world sounds pre-defined in SoundModel enum
- Japanese language UI and comments throughout

**App Initialization:**
- `MeditationJourneyApp.swift`: Entry point with UserDefaults registration
- `UserDefaultsKey.register()` called in app init for default values
- TabSetView serves as main content root with 5-tab navigation
- Core Data PersistenceController injected into environment

**Production Considerations:**
- Replace `fatalError()` in Date extensions with proper error handling
- Update `buildServer.json` workspace path for your environment
- Implement Core Data integration for meditation records
- Replace sample data in ViewModels with proper data services
- Add localization support for international use

**Development Status:**
- **Project Status**: 開発途中 (Under Development)
- **Architecture Goal**: Complete MVVM implementation across all components
- **Current Progress**: CalendarView MVVM refactoring completed
- **Next Steps**: Continue MVVM architecture implementation for remaining views

**Branch Information:**
- Current branch: `feature/49_refactor_calendarview_to_mvvm`
- Recent work: MVVM refactoring of CalendarView completed
- Data structure unified: CalendarInfo → MeditationInfo

**MVVM Implementation Strategy:**
- **Phase 1**: ✅ CalendarView - MVVM refactoring completed
- **Phase 2**: 🔄 Continue refactoring remaining views to MVVM pattern
- **Phase 3**: 📋 Standardize ViewModel inheritance and data flow
- **Phase 4**: 🎯 Replace sample data with proper repository pattern
- **Phase 5**: 🔧 Implement comprehensive state management

## Code Review Guidelines

### Critical Issues (High Priority)

**Error Handling:**
- ❌ Never use `fatalError()` in production code - causes app crashes
- ✅ Use proper error handling with optionals, guard statements, or throws
- ❌ Avoid force unwrapping without proper justification
- ✅ Use guard statements and optional binding for safety

**Common Problems to Check:**
- `Date+Extension.swift` contains multiple `fatalError()` calls for date calculations
- `Persistence.swift` uses `fatalError()` for Core Data errors
- ViewModels have force unwrapping in date calculations

### Naming Conventions (Swift API Design Guidelines)

**Follow Swift Standards:**
- ✅ Use `lowerCamelCase` for variables, methods, and properties
- ✅ Use `UpperCamelCase` for types, protocols, and enums
- ✅ Choose parameter names to serve documentation
- ✅ Make method names read as grammatical English phrases
- ❌ Avoid Hungarian notation and unnecessary abbreviations

**Common Issues to Check:**
- English spelling errors in identifiers (e.g., `nourthAmerica` should be `northAmerica`)
- File header comments showing incorrect filenames
- Inconsistent extension naming patterns

### Code Organization and Structure

**MVVM Pattern Adherence:**
- ✅ Separate concerns clearly between Model, View, and ViewModel
- ✅ Use `@Published` properties for reactive UI updates
- ✅ Views should only call ViewModel methods, never directly access models
- ❌ Avoid sample data in ViewModels - use proper data services

**Extension Organization:**
- ✅ Use extensions to organize code into logical blocks
- ✅ Use `// MARK: -` comments for section separation
- ✅ Prefer separate extensions for protocol conformance
- ✅ Follow consistent naming: `Type+Extension.swift`

### SwiftUI Best Practices

**Performance Considerations:**
- ❌ Don't create Calendar instances inside ForEach loops
- ✅ Move expensive operations outside of view body
- ✅ Use `@State`, `@Published`, and `@ObservedObject` appropriately
- ✅ Minimize view recomputation with proper state management

**Memory Management:**
- ✅ Use `[weak self]` in timer handlers to prevent retain cycles
- ✅ Properly invalidate timers in cleanup methods
- ✅ Consider `deinit` methods for resource cleanup

### Documentation and Comments

**Documentation Standards:**
- ✅ Use triple-slash `///` comments for public APIs
- ✅ Begin with single-sentence summary describing the entity
- ✅ Document computational complexity for non-O(1) operations
- ❌ Avoid redundant comments that state the obvious

**Comment Quality:**
- ✅ Explain **why** code does something, not **what** it does
- ✅ Keep comments up-to-date or remove outdated ones
- ✅ Use English for all comments in international projects
- ❌ Remove excessive comments like "// switch self" after every switch

### Code Style and Formatting

**Follow Established Conventions:**
- ✅ 2-space indentation (Kodeco style) or project-specific standards
- ✅ 100-character line limit (Google style)
- ✅ Open braces on same line, close braces on new line
- ✅ Colons with no space left, one space right

**Code Cleanliness:**
- ✅ Remove unused (dead) code
- ✅ Extract hardcoded values to constants or configuration
- ✅ Minimize imports to only necessary modules
- ❌ Remove debug print statements for production

### Value Types and Protocol-Oriented Programming

**Swift Philosophy:**
- ✅ Prefer value types (structs) over reference types (classes) when appropriate
- ✅ Use protocols for flexible, composable design
- ✅ Leverage protocol-oriented programming patterns
- ✅ Understand value vs reference semantics

### Security and Production Readiness

**Never Commit:**
- ❌ API keys, tokens, or secrets in code
- ❌ Debug logging that exposes sensitive information
- ❌ Hardcoded credentials or configuration

**Production Considerations:**
- ✅ Implement proper error logging framework
- ✅ Replace sample data with real data sources
- ✅ Add comprehensive error handling
- ✅ Consider localization for international use

### Review Checklist

When reviewing Swift code, systematically check:
1. **Safety:** No force unwrapping or `fatalError()` in production paths
2. **Naming:** Follows Swift API Design Guidelines
3. **Structure:** MVVM pattern properly implemented
4. **Performance:** No expensive operations in view bodies or loops
5. **Documentation:** Public APIs properly documented
6. **Style:** Consistent formatting and organization
7. **English:** Correct spelling and grammar in comments/strings
8. **Memory:** Proper resource management and cleanup
9. **Testing:** Code structured for testability
10. **Production:** Ready for deployment without debug artifacts