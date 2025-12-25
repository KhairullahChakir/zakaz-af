# Zakaz-AF Application Report
**Date:** 2025-12-25
**Version:** Development Phase

---

## 1. Executive Summary
**Zakaz-AF** is a multi-vendor e-commerce marketplace tailored for Afghanistan, designed to bridge the gap between local shopkeepers and customers. The platform aims to digitize the local shopping experience, offering a robust mobile application for customers to browse and buy products, and dedicated tools for shopkeepers and administrators to manage the marketplace.

The project is currently in an advanced development stage with core commerce loops, user roles (Customer, Shopkeeper, Admin), and essential features like real-time chat and push notifications fully implemented.

---

## 2. Architecture & Technology Stack

The application follows a standard Client-Server architecture with a RESTful API.

### **Backend (API & Database)**
*   **Framework:** Laravel 11 (PHP)
*   **Database:** MariaDB
*   **Authentication:** Laravel Sanctum (Token-based)
*   **External Services:** Firebase Cloud Messaging (FCM) for push notifications.
*   **Location:** `/backend`

### **Mobile Application (Client)**
*   **Framework:** Flutter 3.x (Cross-platform)
*   **State Management:** Riverpod (with code generation)
*   **Routing:** GoRouter
*   **Networking:** Dio
*   **Storage:** SharedPreferences (Local persistence)
*   **Location:** `/mobile_app`

---

## 3. Application Structure

The repository is organized into two main dedicated directories:

| Directory | Description |
| :--- | :--- |
| **`/backend`** | Contains the Laravel application. Handles API requests, database interactions, authentication logic, and admin/shopkeeper business rules. |
| **`/mobile_app`** | Contains the Flutter code. A single codebase likely serving both Customer and Shopkeeper interfaces via role-based navigation. |
| **`DEV_STATUS.md`** | The central source of truth for project status, feature tracking, and roadmap. |

---

## 4. Current Development Status

The application has successfully implemented the three primary user personas and their critical workflows.

### **✅ Completed Modules**
*   **Authentication:** Secure registration and login for all roles using phone/email.
*   **Customer Experience:**
    *   Product discovery (Search, Sort, Filter).
    *   Cart & Checkout with address management.
    *   Order history and visual status tracking.
    *   Wishlist and Reviews system.
*   **Shopkeeper Ecosystem:**
    *   **Digital Onboarding:** Multi-step application process (Location, Documents, ID) for new sellers.
    *   **Dashboard:** Real-time stats on revenue and orders.
    *   **Inventory:** CRUD operations for products.
*   **Admin Tools:**
    *   Marketplace analytics (Revenue, Top Products).
    *   Shop approval/rejection workflow.
    *   Global catalog management (Categories).
*   **Communication:** Real-time chat between Shopkeepers and Customers with "unread" indicators.
*   **Technical Polish:** 
    *   Dark Mode support.
    *   Offline cart persistence.
    *   Backend Feature Tests for critical paths (Notifications, Orders).

---

## 5. Recommendations & Immediate Next Steps

Based on the current status and feature set, the following steps are recommended to move towards a production release:


2.  **Location Services:** Integrate GPS-based shop discovery to allow customers to find stores near them.
3.  **Testing Strategy:**
    *   Continue expanding Backend Feature Tests.
    *   Consider adding Integration Tests for the Mobile App to ensure the "Happy Path" (Login -> Add to Cart -> Checkout) remains unbroken.
4.  **Deployment Prep:**
    *   Set up a staging environment for the backend.
    *   Configure production-ready assets (icons, splash screens) for the mobile app.
