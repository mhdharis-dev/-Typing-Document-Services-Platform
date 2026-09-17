# 🚀 Apex Typing & Document Services Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.12%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State_Management-Riverpod_3.4-blue?style=for-the-badge)](https://riverpod.dev)
[![GoRouter](https://img.shields.io/badge/Routing-GoRouter_17.5-orange?style=for-the-badge)](https://pub.dev/packages/go_router)
[![License](https://img.shields.io/badge/License-MIT-green.style=for-the-badge)](LICENSE)

A modern, full-featured, cross-platform **Service & Document Assistance Platform** built with Flutter & Riverpod. Designed for typing centers, document clearing agencies, government service providers, and business setup consultants.

The application includes both a **Customer Service Portal** and an **Admin Management Panel** with responsive layouts for Desktop Web, Tablets, and Mobile devices.

---

## 🌟 Key Features

### 👤 Customer Service Portal
- **Interactive Landing & Home Dashboard**:
  - Hero section with instant service search bar.
  - Interactive **Quick Fee Calculator** for instant service cost estimation.
  - Floating **WhatsApp Support Widget** for direct customer assistance.
  - **Government Partners Banner** showcasing official service authorizations.
  - Customer Testimonials, FAQ accordion, and latest news/blog section.
- **Service Catalog & Filtering**:
  - Browse services by category (Visa & Immigration, Emirates ID, Business Setup, Legal Typing, Translation, Attestation, etc.).
  - Search by keywords, price range, or processing timeline.
  - Detailed service page with required document lists, step-by-step procedures, and pricing breakdowns.
- **Multi-Step Service Request Flow**:
  - Intuitive request form pre-filled with service parameters.
  - Document upload portal for applicant documentation.
  - Urgency level selection (Normal, Express, VIP).
  - Instant Request Confirmation with unique tracking ID generation.
- **Request Tracking & History ("My Requests")**:
  - Live status tracking (Pending, In Progress, Waiting Action, Completed, Cancelled).
  - Detailed request timelines with admin notes and downloadable output documents.
- **User Profile & Notifications**:
  - Real-time notification center for status updates.
  - Personal profile management & saved documents repository.
- **Information & Contact**:
  - Company background, operational hours, Google Maps integration, and contact form.

---

### 🛡️ Admin Management Panel
- **Analytics & Dashboard Overview**:
  - Key performance indicators: Total Requests, Completed Orders, Pending Tasks, and Estimated Revenue.
  - Interactive revenue and order metrics charts powered by `fl_chart`.
  - Quick action alerts for requests requiring immediate attention.
- **Service Catalog Management**:
  - Full CRUD operations for services, pricing, processing durations, and dynamic required document templates.
- **Category & Taxonomy Management**:
  - Organize and customize service categories and icons.
- **Request & Workflow Management**:
  - Inspect detailed incoming service requests and attached applicant documents.
  - Update status transitions, append internal notes, attach processed government certificates/visas, and alert customers.
- **Customer User Directory**:
  - View registered user profiles, request histories, and contact info.
- **Content Management System (CMS)**:
  - Manage Testimonials, FAQs, and Blog articles directly from the admin panel.
- **System Settings**:
  - Configure platform parameters, service fees, operating hours, and support contacts.

---

## 📱 Responsive & Adaptive UI Design
- **Desktop Layout**: Dedicated navigation drawer / sidebar with persistent header, max-width content containers, and multi-column grid view.
- **Mobile Layout**: Bottom navigation bar, collapsible mobile top bar, floating action buttons, and touch-optimized input forms.
- **Theme & Styling**: Customized color palette (`AppColors`), polished typography (`Google Fonts`), smooth hover states, micro-interactions, and status chips.

---

## 🛠️ Technology Stack & Architecture

- **Core Framework**: [Flutter](https://flutter.dev) (Web, Android, iOS, Windows, macOS, Linux)
- **Language**: [Dart](https://dart.dev)
- **State Management**: [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod)
- **Navigation & Routing**: [GoRouter](https://pub.dev/packages/go_router)
- **Charts & Data Visualization**: [FL Chart](https://pub.dev/packages/fl_chart)
- **Typography & Icons**: [Google Fonts](https://pub.dev/packages/google_fonts), Cupertino Icons, Material Icons
- **Formatting**: [Intl](https://pub.dev/packages/intl)

### 📂 Directory Structure

```
lib/
├── app/
│   ├── app.dart                   # Main MaterialApp & Theme wrapper
│   ├── router/
│   │   └── app_router.dart        # GoRouter navigation configuration & route definitions
│   └── theme/
│       ├── app_colors.dart        # Color palette tokens
│       ├── app_text_styles.dart   # Typography styles
│       └── app_theme.dart         # Material 3 light/dark theme config
├── core/
│   ├── utils/                     # Formatters, helpers, constants
│   ├── validators/                # Form input validation rules
│   └── widgets/                   # Reusable components
│       ├── admin_sidebar.dart     # Desktop Admin navigation panel
│       ├── admin_bottom_navbar.dart # Mobile Admin navigation
│       ├── user_top_navbar.dart   # Customer header navigation
│       ├── user_bottom_navbar.dart# Mobile customer bottom navigation
│       ├── quick_fee_calculator.dart # Fee estimator component
│       ├── floating_whatsapp_widget.dart # WhatsApp launcher
│       ├── government_partners_banner.dart # Partners banner
│       ├── status_chip.dart       # Request status indicators
│       ├── app_button.dart        # Custom styled buttons
│       ├── app_text_field.dart    # Custom input fields
│       ├── empty_state.dart       # Empty view placeholder
│       └── responsive_layout.dart # Breakpoint layout builder
├── data/
│   ├── mock/                      # Mock data source & mock repositories
│   │   ├── mock_data.dart         # Sample services, requests, blogs, FAQs
│   │   └── mock_repositories.dart # Riverpod state providers & repository logic
│   └── models/                    # Data models
│       ├── service_model.dart
│       ├── request_model.dart
│       ├── category_model.dart
│       ├── customer_model.dart
│       ├── notification_model.dart
│       ├── blog_model.dart
│       ├── faq_model.dart
│       ├── testimonial_model.dart
│       └── settings_model.dart
└── features/                      # Feature modules (UI Screens & Logic)
    ├── onboarding/
    ├── home/                      # Customer home page
    ├── services/                  # Service listing & detail view
    ├── service_request/           # Request creation wizard & confirmation
    ├── requests/                  # My Requests list & detailed status view
    ├── notifications/            # Notification center
    ├── profile/                   # User profile & edit profile
    ├── about/                     # About Us page
    ├── contact/                   # Contact Us page
    └── admin/                     # Admin Portal
        ├── dashboard/             # Admin main dashboard with charts
        ├── services/              # Service CRUD management
        ├── categories/            # Category management
        ├── requests/              # Request processing workflow
        ├── customers/             # Customer directory
        ├── documents/             # Document repository
        ├── testimonials/          # Testimonials CMS
        ├── faq/                   # FAQ CMS
        ├── blog/                  # Blog CMS
        └── settings/              # Admin system settings
```

---

## ⚡ Getting Started

### Prerequisites

Make sure you have the following installed on your machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.12.1`)
- [Dart SDK](https://dart.dev/get-dart) (`>=3.0.0`)
- Git (`>=2.0.0`)
- An IDE (VS Code or Android Studio) with Flutter & Dart extensions

---

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git
   cd "Service & Document Assistance Platform"
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the Application**

   - **Web (Chrome)**:
     ```bash
     flutter run -d chrome
     ```

   - **Android / iOS**:
     ```bash
     flutter run
     ```

   - **Windows Desktop**:
     ```bash
     flutter run -d windows
     ```

---

## 📤 How to Push This Project to GitHub

If you are initializing git for the first time and pushing this codebase to GitHub, follow these step-by-step instructions:

### Step 1: Initialize Git Repository
Run the following command in your terminal inside the project root directory:
```bash
git init
```

### Step 2: Add All Files to Staging
```bash
git add .
```

### Step 3: Create Initial Commit
```bash
git commit -m "feat: initial commit for Apex Typing & Document Services Platform"
```

### Step 4: Rename Branch to `main`
```bash
git branch -M main
```

### Step 5: Link Local Repository to Remote GitHub Repo
Create a new empty repository on [GitHub](https://github.com/new) (do **not** check "Initialize with README"), then run:
```bash
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git
```
*(Replace `YOUR_USERNAME` and `YOUR_REPOSITORY_NAME` with your actual GitHub username and repository name).*

### Step 6: Push to GitHub
```bash
git push -u origin main
```

---

## 🌐 Routes Overview

| Route | View Description | Access Level |
|---|---|---|
| `/home` | Customer Landing Page & Services Overview | Public |
| `/services` | Service Catalog & Category Filter | Public |
| `/services/:id` | Detailed Service Information & Document Guide | Public |
| `/request-service` | Multi-step Service Request Form | Customer |
| `/requests/confirmation` | Request Submission Confirmation | Customer |
| `/requests` | My Requests Tracking Dashboard | Customer |
| `/requests/:id` | Individual Request Timeline & Details | Customer |
| `/notifications` | User Notifications Center | Customer |
| `/profile` | User Profile & Document Vault | Customer |
| `/about` | About Company Information | Public |
| `/contact` | Contact Us & Inquiry Form | Public |
| `/admin/dashboard` | Admin Metrics Dashboard & Revenue Chart | Admin |
| `/admin/services` | Service Catalog Management | Admin |
| `/admin/requests` | Customer Order & Request Workflow | Admin |
| `/admin/customers` | Registered Customer Profiles | Admin |
| `/admin/documents` | Shared Document Vault | Admin |
| `/admin/settings` | Platform Configurations | Admin |

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to check the [issues page](https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME/issues).

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📜 License

Distributed under the **MIT License**. See `LICENSE` for more information.

---

## ✉️ Support & Contact

- **Project**: Apex Typing & Document Services Platform
- **Developer**: Developer Team
- **Email**: support@apextyping.com
- **WhatsApp**: Live Support Integrated in App
#   - T y p i n g - D o c u m e n t - S e r v i c e s - P l a t f o r m  
 