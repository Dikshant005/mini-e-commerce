# My Shop Simple

A simple e-commerce app built with Flutter, featuring Firebase authentication, product listing, cart management, and wishlist functionality.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
  - [Running Tests](#running-tests)
- [Overview](#overview)
  - [Features](#features-1)
  - [Architecture and Design Decisions](#architecture-and-design-decisions)
- [Folder Structure](#folder-structure)
- [Adding Screenshots or Screen Recordings](#adding-screenshots-or-screen-recordings)


## Features

- **User Authentication**: Firebase-based login and registration.
- **Product Listing**: Fetch and display products from a remote API.
- **Offline Support**: Cache products using Hive for offline access.
- **Cart Management**: Add and remove products from the cart.
- **Wishlist**: Save favorite products to a wishlist.
- **Dark Mode**: Toggle between light and dark themes.

## Getting Started

### Prerequisites

- Flutter SDK installed and configured.
- Android Studio or VS Code for development.
- Firebase project set up with authentication enabled.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/my_shop_simple.git
2. Navigate to the project directory:
   ```bash
   cd my_shop_simple
3. Install dependencies:
    ```bash
    flutter pub get
4. Running the App:
   Connect a device or start an emulator.
    ```bash
    flutter run
### Running Tests
 1. Run unit tests:
    ```bash
    flutter test
2. Run integration tests:
    ```bash
    flutter test integration_test/app_test.dart --dart-define=INTEGRATION_TEST=true

## Overview
### Features
- User Authentication: Firebase-based login and registration.
- Product Listing: Fetch and display products from a remote API.
- Offline Support: Cache products using Hive for offline access.
- Cart Management: Add and remove products from the cart.
- Wishlist: Save favorite products to a wishlist.
- Dark Mode: Toggle between light and dark themes.

### Architecture and Design Decisions
The project follows a modular architecture to ensure scalability and maintainability. Here are the key decisions:

- State Management: The app uses the BLoC (Business Logic Component) pattern for state management. This pattern separates the business logic from the UI, making it easier to manage and test.
- Dependency Injection: Dependency injection is implemented using the get_it package to manage dependencies throughout the app.
- Networking: The dio package is used for making HTTP requests to fetch product data from a remote API.
- Local Storage: The hive package is used for caching products to support offline functionality.
- Routing: The app uses named routes for navigation, making it easier to manage and test navigation logic.

## Folder Structure

The project is organized into the following main directories:

- `lib/`: Contains the main source code.
  - `core/`: Core models and services.
    - `models/`: Data models like `product.dart`.
    - `services/`: Services like `cache_service.dart`.
  - `features/`: Feature-specific logic and UI.
    - `auth/`: Authentication-related logic and UI.
    - `products/`: Product listing and details.
    - `cart/`: Cart management.
    - `wishlist/`: Wishlist management.
  - `main.dart`: Entry point of the application.
- `test/`: Contains unit and widget tests.
  - `features/`: Tests for feature-specific logic.
  - `widgets/`: Tests for custom widgets.
- `integration_test/`: Contains integration tests.


### Screenshots

![Login Screen](https://github.com/user-attachments/assets/a2fa7670-bf70-4932-9f51-ac9c13446726)


![Product Listing](https://github.com/user-attachments/assets/adcf82d4-c68d-4867-9c15-8581f201740e)


![Product Details](https://github.com/user-attachments/assets/d2e41d0f-a966-4144-9b61-928a8bb099f5)

![Cart](https://github.com/user-attachments/assets/77c077bd-ed5a-479e-8f22-52ded541f007)

![Wishlist](https://github.com/user-attachments/assets/a30726ff-1067-46af-bf89-7d87121a8405)

### Screen Recording

[[![Screen Recording](https://github.com/user-attachments/assets/adcf82d4-c68d-4867-9c15-8581f201740e)](https://www.youtube.com/watch?v=your_video_id)](https://github.com/user-attachments/assets/6560e3ac-aca8-4e85-9aa6-318568392c09)


