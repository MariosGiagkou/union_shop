# 🛍️ Union Shop - Flutter E-Commerce Application

A comprehensive e-commerce Flutter application built for the University of Portsmouth Student Union. This app replicates the functionality of the [UPSU Shop website](https://shop.upsu.net) with a modern, responsive Flutter implementation featuring Firebase integration for authentication, real-time database, and cloud storage.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Integrated-orange.svg)


## ✨ Key Features

### 🏪 E-Commerce Functionality
- **Product Catalog**: Browse products with real-time Firebase Firestore integration
- **Dynamic Collections**: Filter and sort products by categories (Essentials, Graduation, Sale, etc.)
- **Product Search**: Full-text search functionality across all products
- **Shopping Cart**: Add, update, and remove items with persistent state management
- **Order Checkout**: Complete purchase flow with Firebase order management
- **Order History**: View past orders (Firebase authenticated users only)

### 🎨 Print Shack Personalization
- **Custom Product Designer**: Interactive form for personalizing merchandise
- **Dynamic Options**: Configurable product options (colors, sizes, quantities)
- **Image Upload Support**: Preview and customize product designs

### 🔐 Authentication System
- **Firebase Authentication**: Secure user sign-in and registration
- **Email/Password Login**: Traditional authentication method
- **Session Management**: Persistent user sessions with Provider state management
- **Protected Routes**: Order history and checkout require authentication

### 📱 Responsive Design
- **Mobile-First**: Optimized layouts for smartphones (375px - 767px)
- **Tablet Support**: Adaptive design for tablets (768px - 1023px)
- **Desktop Ready**: Full-screen layouts for desktops (1024px+)
- **Collapsible Navigation**: Mobile hamburger menu with smooth transitions

### 🎯 Advanced UI/UX
- **Auto-Rotating Hero Carousel**: Smooth product showcase with timer
- **Smooth Animations**: Page transitions and hover effects
- **Error Handling**: User-friendly error messages and fallbacks

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

### Required Software
- **Flutter SDK**: Version 3.0.0 or higher
  - [Download Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: Version 2.17.0 or higher (bundled with Flutter)
- **IDE**: One of the following:
  - [Android Studio](https://developer.android.com/studio) with Flutter plugin
  - [VS Code](https://code.visualstudio.com/) with Flutter extension
  - [IntelliJ IDEA](https://www.jetbrains.com/idea/) with Flutter plugin

### Platform-Specific Requirements

**For Android Development:**
- Android SDK (API level 21 or higher)
- Android Emulator or physical device

**For iOS Development (macOS only):**
- Xcode 13.0 or higher
- iOS Simulator or physical device
- CocoaPods (`sudo gem install cocoapods`)

**For Web Development:**
- Chrome browser (for debugging)

### Firebase Setup
- Google account for Firebase Console access
- Firebase project configured with:
  - Firestore Database
  - Authentication (Email/Password enabled)
  - Storage (optional, for image uploads)

## 🚀 Installation and Setup

### 1. Clone the Repository

```bash
git clone https://github.com/MariosGiagkou/union_shop.git
cd union_shop
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

#### Option A: Use Existing Firebase Project
The project includes pre-configured Firebase settings in `lib/firebase_options.dart`. This connects to a demo Firebase project.

#### Option B: Set Up Your Own Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable **Firestore Database** and **Authentication**
4. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```
5. Login to Firebase:
   ```bash
   firebase login
   ```
6. Configure FlutterFire:
   ```bash
   flutterfire configure
   ```
7. Select your Firebase project and platforms
8. This will generate/update `lib/firebase_options.dart`

#### Set Up Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **Create Database** → Start in **Test Mode**
3. Create a `products` collection with sample documents:

```json
{
  "title": "Essential T-Shirt",
  "price": "12.99",
  "discountPrice": "9.99",
  "imageUrl": "assets/images/essential_t-shirt.webp",
  "category": "essentials",
  "description": "Comfortable cotton t-shirt"
}
```

#### Enable Authentication

1. Go to **Authentication** → **Sign-in method**
2. Enable **Email/Password** provider
3. (Optional) Add test users in the **Users** tab

### 4. Run the Application

```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices          # List available devices
flutter run -d chrome    # Run on Chrome (web)
flutter run -d android   # Run on Android
flutter run -d ios       # Run on iOS
```

### 5. Build for Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🎮 Usage Instructions

### Main Features

#### 1. Browse Products
- **Home Page**: View featured products and collections
- **Collections Page**: Filter by category (Essentials, Graduation, Apparel, etc.)
- Click on any product to view details

#### 2. Search Products
- Use the search bar in the navigation header
- Enter keywords (e.g., "hoodie", "t-shirt")
- View real-time search results
- Click to view product details

#### 3. Shopping Cart
- Click "Add to Cart" on any product page
- Adjust quantities using +/- buttons
- Remove items with the delete icon
- View cart total in the header (shows item count)
- Navigate to `/cart` to review and checkout

#### 4. Checkout Process
1. Add items to cart
2. Click "Checkout" button
3. Sign in if not authenticated (redirects to `/sign-in`)
4. Confirm order details
5. Order is saved to Firebase Firestore
6. Cart is cleared upon successful checkout

#### 5. Order History
- Navigate to `/order-history`
- Requires authentication (redirects to sign-in if not logged in)
- View all past orders with:
  - Order date
  - Items purchased
  - Total amount
  - Order status (pending, completed, cancelled)

#### 6. Personalize Products (Print Shack)
- Navigate to `/personalise`
- Select product type
- Choose customization options (colors, text, logos)
- Add personalized item to cart

#### 7. User Authentication
- Click "Sign In" in navigation
- **Sign Up**: Create new account with email/password
- **Sign In**: Login with existing credentials
- **Sign Out**: Click user icon → Sign Out

### Configuration Options

#### Running in Different Environments

```bash
# Debug mode (default)
flutter run

# Profile mode (performance testing)
flutter run --profile

# Release mode (production)
flutter run --release
```

#### Firebase Emulator (Local Development)

```bash
# Install Firebase emulators
firebase init emulators

# Run emulators
firebase emulators:start

# Update code to use emulators (in main.dart)
# FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
```

## 🧪 Testing

### Running Tests

The project includes comprehensive unit and widget tests with **~60% code coverage**.

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/views/home_page_tests/home_page_test.dart

# Run tests in Chrome (for debugging)
flutter test --platform chrome
```



### Test Structure

```
test/
├── helpers/
│   └── test_helpers.dart          # Reusable test utilities
├── models/
│   ├── cart_item_test.dart        # CartItem model tests
│   ├── order_test.dart            # Order model tests
│   └── layout_test.dart           # Layout widget tests
├── repositories/
│   └── cart_repository_test.dart  # Cart state management tests
├── services/
│   ├── auth_service_test.dart     # Authentication tests
│   └── order_service_mocked_test.dart
├── views/
│   ├── home_page_tests/
│   ├── cart_page_tests/
│   ├── collections_page_tests/
│   ├── search_page_tests/
│   └── ...
└── widgets/
    └── product_card_test.dart
```

### Dependency Injection for Mock Testing

To achieve high test coverage, the project uses **dependency injection** to allow Firebase services to be replaced with mock implementations during testing.

#### Implementation Pattern

Instead of directly using Firebase instances, widgets accept optional parameters that default to real Firebase instances in production but can be overridden with mocks in tests:

**Example from `collections_page.dart`:**
```dart
class CollectionsPage extends StatefulWidget {
  final FirebaseFirestore? firestore;  // Optional parameter for testing
  
  const CollectionsPage({super.key, this.firestore});
  
  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  void initState() {
    super.initState();
    // Use injected mock or default to real Firebase instance
    final firestore = widget.firestore ?? FirebaseFirestore.instance;
    // Use 'firestore' variable throughout the widget
  }
}
```

#### Testing Implementation

In tests, we inject `FakeFirebaseFirestore` from the `fake_cloud_firestore` package:

```dart
testWidgets('displays products from Firestore', (tester) async {
  final fakeFirestore = FakeFirebaseFirestore();
  
  // Populate mock data
  await fakeFirestore.collection('products').add({
    'title': 'Test Product',
    'price': '19.99',
    'category': 'essentials',
  });
  
  // Inject mock into widget
  await tester.pumpWidget(
    MaterialApp(
      home: CollectionsPage(firestore: fakeFirestore),
    ),
  );
  
  await tester.pumpAndSettle();
  
  // Verify product appears
  expect(find.text('Test Product'), findsOneWidget);
});
```

#### Benefits

1. **Testability**: No network calls in tests - fast, deterministic results
2. **Isolation**: Tests don't depend on external Firebase project state
3. **Flexibility**: Easy to test edge cases (empty data, errors, loading states)
4. **Production Safety**: Default behavior uses real Firebase - zero impact on production code

#### Libraries Used

- **fake_cloud_firestore** (4.0.0): Mock Firestore implementation with in-memory database
- **firebase_auth_mocks** (0.15.1): Mock Firebase Authentication for user session testing

### Why No Order History Tests?

**Firebase Integration Complexity**: Order history functionality relies heavily on Firebase Firestore real-time listeners and authenticated user sessions. Testing this requires:

1. **Complex Mocking**: Order history uses `StreamBuilder` with Firebase Firestore snapshots, which are challenging to mock accurately
2. **Authentication Dependencies**: Tests need both `AuthService` and `OrderService` providers, plus `CartRepository` (used by the SiteHeader)
3. **Provider Scoping Issues**: The widget tree requires multiple providers in specific scopes, making test setup error-prone
4. **Real-time Data**: Firestore's real-time listeners don't translate well to mock environments

**Current Approach**: 
- Order history has basic instantiation tests to verify the page can be created
- The actual Firebase integration is tested manually in development
- Other similar pages (personalise, collections, search) have comprehensive mocked tests using `fake_cloud_firestore` and `firebase_auth_mocks`



## 📁 Project Structure

```
union_shop/
├── lib/
│   ├── main.dart                      # App entry point, routing configuration
│   ├── firebase_options.dart          # Firebase configuration
│   │
│   ├── models/                        # Data models
│   │   ├── cart_item.dart             # Shopping cart item model
│   │   ├── order.dart                 # Order model
│   │   └── layout.dart                # Reusable layout components (SiteHeader, SiteFooter)
│   │
│   ├── views/                         # UI screens
│   │   ├── home_page.dart             # Landing page with carousel
│   │   ├── product_page.dart          # Individual product details
│   │   ├── collections_page.dart      # Product category listings
│   │   ├── search_page.dart           # Product search interface
│   │   ├── cart_page.dart             # Shopping cart
│   │   ├── order_history_page.dart    # Order history (auth required)
│   │   ├── personalise_page.dart      # Print Shack customization
│   │   ├── sign_in.dart               # Authentication page
│   │   ├── about_us.dart              # About Union Shop
│   │   └── about_us_printshack.dart   # About Print Shack
│   │
│   ├── repositories/                  # State management
│   │   └── cart_repository.dart       # Cart state with ChangeNotifier
│   │
│   └── services/                      # Business logic
│       ├── auth_service.dart          # Firebase Authentication wrapper
│       └── order_service.dart         # Firestore order operations
│
├── assets/
│   └── images/                        # Product images, logos
│       ├── logo.avif
│       ├── essential_t-shirt.webp
│       ├── signature_hoodie.webp
│       └── ...
│
├── test/                              # Unit and widget tests
│   ├── helpers/
│   │   └── test_helpers.dart          # Mock providers, test utilities
│   ├── models/                        # Model tests (22 tests)
│   ├── repositories/                  # Repository tests
│   ├── services/                      # Service tests with mocks
│   ├── views/                         # Widget tests (300+ tests)
│   └── widgets/                       # Component tests
│
├── android/                           # Android-specific code
├── ios/                               # iOS-specific code
├── web/                               # Web-specific code
├── windows/                           # Windows-specific code (desktop)
│
├── pubspec.yaml                       # Dependencies and assets
├── analysis_options.yaml              # Linter rules
├── firebase.json                      # Firebase configuration
└── README.md                          # This file
```

### Key Files Explained

| File | Purpose |
|------|---------|
| `lib/main.dart` | App initialization, GoRouter setup, Provider configuration |
| `lib/models/layout.dart` | Reusable `SiteHeader` and `SiteFooter` widgets |
| `lib/repositories/cart_repository.dart` | Shopping cart state management (Provider) |
| `lib/services/auth_service.dart` | Firebase Authentication wrapper |
| `lib/services/order_service.dart` | Firestore order CRUD operations |
| `lib/firebase_options.dart` | Auto-generated Firebase config |
| `test/helpers/test_helpers.dart` | `pumpWithProviders()` utility for widget tests |

## � Libraries & Dependencies

This project uses carefully selected libraries to provide robust functionality while maintaining code quality and testability. Below is a comprehensive list of all dependencies and their purposes.

### Production Dependencies

#### Core Framework
- **`flutter`** (SDK)
  - **Purpose**: The Flutter framework itself - enables cross-platform mobile, web, and desktop development
  - **Used For**: Building the entire UI and application structure

- **`flutter_web_plugins`** (SDK)
  - **Purpose**: Web-specific plugins for Flutter web apps
  - **Used For**: URL strategy management (removes the `#` hash from web URLs for cleaner routing)
  - **Key Usage**: `usePathUrlStrategy()` in `main.dart` for clean URLs like `/products` instead of `/#/products`

#### UI Components & Icons
- **`cupertino_icons`** (^1.0.0)
  - **Purpose**: iOS-style icons for Flutter applications
  - **Used For**: Cross-platform icon consistency, fallback icons for Material Design
  - **Example**: iOS-style icons in navigation and buttons

#### Firebase Backend Services
- **`firebase_core`** (^4.2.1)
  - **Purpose**: Core Firebase SDK - initializes Firebase services
  - **Used For**: Connecting the app to Firebase project, prerequisite for all Firebase features
  - **Key Usage**: `Firebase.initializeApp()` in `main.dart`

- **`cloud_firestore`** (^6.1.0)
  - **Purpose**: NoSQL cloud database by Firebase
  - **Used For**: 
    - Storing and retrieving product catalog data
    - Managing user order history
    - Real-time product updates via snapshot streams
  - **Collections Used**: `products`, `orders`
  - **Key Features**: Real-time listeners, offline persistence, scalable queries

- **`firebase_auth`** (^6.1.2)
  - **Purpose**: Firebase Authentication SDK
  - **Used For**:
    - User registration (email/password)
    - User sign-in/sign-out
    - Session management
    - Protecting routes (order history, checkout)
  - **Provider Used**: Email/Password authentication

#### Routing & Navigation
- **`go_router`** (^17.0.0)
  - **Purpose**: Declarative routing package for Flutter
  - **Used For**:
    - Named route navigation (`/home`, `/cart`, `/product`, etc.)
    - Deep linking support (direct URLs to specific pages)
    - Query parameters (search queries, product IDs)
    - Nested routes (collections → category → product)
  - **Why Chosen**: Superior to `Navigator 1.0`, type-safe, supports web URLs natively
  - **Key Features**: 
    - Path parameters (e.g., `/collections/:category`)
    - Extra data passing between routes
    - Programmatic navigation with `context.go()` and `context.goNamed()`

#### State Management
- **`provider`** (^6.1.1)
  - **Purpose**: Recommended state management solution by Flutter team
  - **Used For**:
    - Shopping cart state (`CartRepository` with `ChangeNotifier`)
    - User authentication state (`AuthService`)
    - Dependency injection for services (`OrderService`)
  - **Why Chosen**: Simple, lightweight, officially recommended, great for medium-sized apps
  - **Providers Used**:
    - `ChangeNotifierProvider`: Cart and Auth state
    - `Provider`: Order service dependency injection
  - **Key Features**: Reactive UI updates, scoped access, testability

#### Utilities
- **`intl`** (^0.19.0)
  - **Purpose**: Internationalization and localization utilities
  - **Used For**:
    - Date formatting (order dates in `order_history_page.dart`)
    - Number formatting (currency display)
    - Future support for multi-language translations
  - **Key Usage**: `DateFormat` for displaying formatted order dates

---

### Development Dependencies

#### Testing Frameworks
- **`flutter_test`** (SDK)
  - **Purpose**: Built-in testing framework for Flutter
  - **Used For**:
    - Unit tests (models, services, repositories)
    - Widget tests (UI component testing)
    - Integration tests

#### Code Quality & Linting
- **`flutter_lints`** (^2.0.0)
  - **Purpose**: Official Flutter linting rules recommended by the Flutter team
  - **Used For**:
    - Enforcing code style consistency
    - Catching potential bugs and anti-patterns
    - Maintaining best practices
  - **Rules Enforced**: 
    - Proper const usage
    - Avoiding deprecated APIs
    - Naming conventions
    - Code formatting standards

#### Testing Mocks & Fakes
- **`fake_cloud_firestore`** (^4.0.0)
  - **Purpose**: In-memory fake implementation of Cloud Firestore
  - **Used For**:
    - Unit testing Firebase Firestore operations without real database
    - Mocking collections, documents, queries, and snapshots
    - Fast, deterministic tests without network calls
  - **Key Benefit**: Tests run offline and ~100x faster than Firebase emulators
  - **Used In**: 
    - `order_service_mocked_test.dart`: Testing order CRUD operations
    - `collections_page_tests/`: Testing product filtering and queries

- **`firebase_auth_mocks`** (^0.15.1)
  - **Purpose**: Mock implementation of Firebase Authentication
  - **Used For**:
    - Testing authentication flows without real Firebase Auth
    - Simulating signed-in/signed-out states
    - Testing protected routes and user-specific features
  - **Key Benefit**: Consistent, controllable test environment
  - **Used In**:
    - `auth_service_test.dart`: Testing sign-in, sign-up, sign-out
    - Widget tests requiring authenticated users

---

### Why These Libraries Were Chosen

#### Architecture Decisions

1. **Firebase Ecosystem** (Core, Firestore, Auth)
   - **Reason**: Rapid development without building custom backend
   - **Benefits**: 
     - Managed infrastructure (no server maintenance)
     - Real-time data synchronization
     - Built-in security rules
     - Automatic scaling
     - Free tier sufficient for development/testing
   - **Trade-off**: Vendor lock-in, but offset by ease of development

2. **Provider for State Management**
   - **Reason**: Officially recommended, simple learning curve
   - **Alternatives Considered**: BLoC (too complex for this scope), Riverpod (newer but less mature)
   - **Benefits**:
     - Minimal boilerplate
     - Great documentation
     - Built-in dependency injection
     - Easy to test with mocks

3. **go_router for Navigation**
   - **Reason**: Best routing solution for Flutter web + mobile
   - **Alternatives Considered**: Navigator 2.0 (too verbose), auto_route (code generation overhead)
   - **Benefits**:
     - Declarative routing
     - Deep linking out-of-the-box
     - Type-safe navigation
     - Clean URL structure on web

4. **Mock Libraries for Testing** (fake_cloud_firestore, firebase_auth_mocks)
   - **Reason**: Achieve high test coverage without Firebase dependency
   - **Benefits**:
     - Tests run in milliseconds (no network I/O)
     - No Firebase project setup required for CI/CD
     - Deterministic test results
     - Can test offline scenarios
   - **Result**: 60% code coverage with fast, reliable tests

---

### Dependency Version Strategy

- **Caret (`^`) Versioning**: Used for all dependencies (e.g., `^6.1.0`)
  - Allows minor and patch updates automatically
  - Maintains compatibility with major version
  - Example: `^6.1.0` accepts `6.1.1`, `6.2.0` but not `7.0.0`

- **SDK Dependencies**: Flutter and Flutter Web Plugins use `sdk: flutter`
  - Ensures compatibility with Flutter version
  - Updated when Flutter SDK is updated

---

### How to View Installed Versions

```bash
# View all dependencies and their resolved versions
flutter pub deps

# Check for outdated packages
flutter pub outdated

# Upgrade dependencies to latest compatible versions
flutter pub upgrade
```


### Current Limitations

1. **Order History Testing**
   - **Issue**: No comprehensive widget tests for `order_history_page.dart`
   - **Reason**: Complex Firebase Firestore integration with real-time streams makes mocking difficult
   - **Impact**: Only basic instantiation tests exist (1% coverage)
   - **Workaround**: Manual testing in development environment
   - **See**: [Why No Order History Tests?](#why-no-order-history-tests) section above

### Performance Notes

- Initial app load may take 2-3 seconds due to Firebase initialization



## 👨‍💻 Author
## 📞 Contact Info

1. GitHub:https://github.com/MariosGiagkou
2. Gmail:Mariosyiangou99@gmail.com

---

**Built with ❤️ using Flutter and Firebase**

*Last Updated: December 2025*
