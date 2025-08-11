
SnapEZ: The name is derived from 'Snapping Easy'—the idea of saving cards and tapping to use them with maximum simplicity and speed. This project is a modern Flutter card management application focused on secure, efficient, and user-friendly storage and management of payment card details. It combines advanced validation, PIN protection, country ban logic, expiry notifications, and a robust MVVM+BLoC architecture for reliability and extensibility.

1. Project Overview
   a. SnapEZ is a Flutter card management application built with Dart, using MVVM and BLoC for scalable, maintainable architecture.
   - The app provides secure, efficient, and user-friendly storage of payment card details.
   - Real-time validation, PIN protection, country ban logic, and expiry notifications are core features.
   - Designed for extensibility, security, and robust offline operation.

2. Key Features
   a. Card Management
      - Users can add cards via scan (OCR) or manual entry. Card scanning uses `card_scanner` and `flutter_credit_card_scanner` for fast, accurate input.
      - Card type and bank name are auto-detected using card number and BIN logic. Example: BIN '400000' maps to 'Bank of America'.
      - Duplicate card prevention is enforced at the repository level using indexed queries.
   b. Security
      - Each card requires a PIN, stored securely using `flutter_secure_storage` and encrypted at rest.
      - Card data is stored in a local SQLite database via `sqflite`, with schema migrations supported for future extensibility.
   c. Country Ban Logic
      - The app checks country and card type against a ban list before saving. Banned logic is enforced in both UI and repository layers.
      - If banned, a modal dialog explains the restriction and blocks the save. Example: MasterCard banned in 'CountryX'.
   d. Validation
      - Card number is validated using the Luhn algorithm and brand-specific length checks. Example: Visa (13/16/19 digits), Amex (15 digits).
      - CVV, expiry, country, and PIN are required and validated in real-time. Expiry must match MM/YY format and be in the future.
      - All validation logic is centralized in the ViewModel layer for testability.
   e. Notifications
      - Expiry notifications are auto-generated when a card is 3 months from expiry. NotificationModel includes title, body, read status, and timestamp.
      - Notification badge and modal allow users to view, mark as read, or dismiss alerts. NotificationBloc manages state and event flow.
      - Example: Card expiring in November triggers notification in August.
   f. Quick Actions & Navigation
      - Home dashboard provides quick actions for cards, transactions, and settings. Navigation is modular and centralized in `NavActions`.
      - All navigation flows are covered by widget and integration tests.

3. Architecture
   a. MVVM + BLoC Pattern
      - Models: CardModel, NotificationModel, CountryStatus, etc. All models use Equatable for efficient state comparison.
      - ViewModels: CardViewModel, NotificationViewModel encapsulate business logic, validation, and repository interaction.
      - Repositories: CardRepository (abstract), CardRepoImpl (SQLite), NotificationRepository, NotificationRepoImpl. All repositories support async CRUD operations.
      - BLoC: CardBloc, NotificationBloc manage state and events for cards and notifications. Events and states are fully typed and covered by unit tests.
      - UI: Modular screens (home, add card, card list, notifications, settings) and reusable components. All screens use BlocBuilder for reactive updates.
   b. Navigation
      - Navigation actions are centralized in `NavActions` for consistency and testability. Example: `NavActions.showCardsAction(context)`.
      - Deep linking and route management are supported for future extensibility.

4. Data Flow Example: Add Card
   a. User enters card details or scans card.
   b. ViewModel validates input (Luhn, length, banned country, required fields).
   c. Repository checks for duplicates and banned logic.
   d. If valid, card is saved to SQLite and PIN is stored securely.
   e. CardBloc emits CardAdded and CardsLoaded states; UI updates automatically.
   f. If expiry is within 3 months, NotificationRepoImpl creates a notification.

5. Database Schema
   a. Cards Table
      - id: INTEGER PRIMARY KEY AUTOINCREMENT
      - firstName, lastName, cardNumber, cvv, expiry, country, city, pin, cardType, bankName
      - All sensitive fields are encrypted or stored securely.
   b. Notifications Table
      - id: INTEGER PRIMARY KEY AUTOINCREMENT
      - title, body, read (bool), date (timestamp), cardId (FK)
      - Linked to Cards table for expiry notifications.
   c. Migrations
      - Schema is designed for easy migration; new fields can be added with versioning.

6. Validation Algorithms
   a. Luhn Algorithm
      - Used for card number validation. Ensures only valid card numbers are accepted.
   b. Brand Detection
      - Card type detected by prefix and length. Example: '4' for Visa, '5' for MasterCard.
   c. Country Ban Logic
      - List of banned card types per country is checked before saving.
   d. Expiry Validation
      - Expiry date must be in MM/YY format and in the future.

7. Testing Strategy
   a. Widget Tests
      - Validate UI rendering, navigation, error dialogs, notification badge.
   b. Logic Tests
      - BLoC, event, state, repository, and view model logic are tested in isolation.
   c. System Tests
      - End-to-end workflows for adding, removing, and validating cards, including country ban and expiry notification logic.
   d. Coverage
      - All business logic, validation, and navigation flows are covered by tests. No external test packages required for basic coverage.

8. Security and Extensibility
   a. PIN and card data are encrypted and stored securely.
   b. SQLite schema supports migrations for future fields.
   c. Modular codebase allows for easy addition of new features (cloud sync, analytics, multi-user support).
   d. All business logic is testable and covered by unit and integration tests.

9. Getting Started
   a. Setup
      - Clone the repository and run `flutter pub get` to install dependencies.
      - Start the app with `flutter run`.
      - Run all tests with `flutter test`.
   b. File Structure
      - lib/: Main app code (models, views, bloc, repositories, components)
      - test/: Widget, logic, and system tests
      - pubspec.yaml: Dependencies and asset management

10. License
   - MIT

11. SOLID Principles Usage
   a. The codebase applies Single Responsibility Principle: each class and module has one clear responsibility. For example, CardModel only represents card data, while CardRepository handles data persistence. Validation logic is centralized in ViewModels, keeping UI and business logic separate.
   b. Open/Closed Principle: models, repositories, and BLoC classes are designed to be extended without modification. New card types or notification logic can be added by extending existing models or repositories. The database schema supports migrations for future extensibility.
   c. Liskov Substitution Principle: abstract repositories (CardRepository, NotificationRepository) define contracts that all implementations (CardRepoImpl, NotificationRepoImpl) adhere to, allowing seamless substitution.
   d. Interface Segregation Principle: interfaces and abstract classes are focused and minimal. Repository interfaces only expose necessary CRUD operations, keeping implementations clean and focused.
   e. Dependency Inversion Principle: high-level modules (UI, BLoC, ViewModels) depend on abstractions, not concrete implementations. Dependency injection is used for repositories and services, enabling easy testing and swapping of implementations.
   f. Example usage: models use Equatable for efficient state comparison and immutability. Repositories are abstracted and injected, supporting async CRUD and validation logic. BLoC classes manage state and events, decoupled from UI and data layers. UI components are modular, reusable, and only depend on abstractions.
   g. All business logic, validation, and navigation flows are covered by unit and integration tests. The modular codebase allows for easy addition of new features (cloud sync, analytics, multi-user support).

12. Refactoring and Design
   a. All major files have been updated for code quality, maintainability, and extensibility. 
   b. Models, repositories, BLoC/event/state, and UI screens follow robust SOLID design and best practices.
   c. Error handling is implemented throughout using try/catch, error screens, and fallback UI for reliability.
   d. Accessibility and responsive design are prioritized in all screens and components.
   e. Modern UI/UX features include glassmorphism, quick actions, notification badges, and modular navigation.
   
13. Test Upgrades
   a. Unit tests and widget tests have been upgraded to cover new business logic, validation, and navigation flows.
   b. Test coverage includes repository logic, BLoC/event/state, view models, and UI workflows.
   c. All tests are updated for new interfaces, copyWith methods, and error handling logic.