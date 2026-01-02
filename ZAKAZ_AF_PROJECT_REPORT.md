# Zakaz-AF E-Commerce Platform
## Complete Project Report

**Project Name:** Zakaz-AF  
**Developer:** Khairullah Chakir  
**Completion Date:** January 2, 2026  
**Platform:** Android Mobile Application with Laravel Backend  
**Live URL:** https://zakaz-af.store  
**API Endpoint:** https://api.zakaz-af.store/api

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Project Overview](#2-project-overview)
3. [Technical Architecture](#3-technical-architecture)
4. [Technology Stack](#4-technology-stack)
5. [Mobile Application Features](#5-mobile-application-features)
6. [Backend API](#6-backend-api)
7. [Database Design](#7-database-design)
8. [Security Implementation](#8-security-implementation)
9. [Deployment Infrastructure](#9-deployment-infrastructure)
10. [Localization & Internationalization](#10-localization--internationalization)
11. [User Roles & Permissions](#11-user-roles--permissions)
12. [Cost Analysis](#12-cost-analysis)
13. [Future Enhancements](#13-future-enhancements)
14. [Conclusion](#14-conclusion)

---

## 1. Executive Summary

Zakaz-AF is a comprehensive e-commerce mobile application designed specifically for the Afghan market. The platform enables local Afghan shopkeepers to sell their products online while providing customers with a convenient way to shop for groceries, fashion, electronics, and more with home delivery.

### Key Achievements:
- ✅ Fully functional Android mobile application
- ✅ Secure Laravel REST API backend
- ✅ Production deployment with SSL/HTTPS
- ✅ Multi-language support (English, Dari, Pashto)
- ✅ Real-time chat between buyers and sellers
- ✅ Push notifications for order updates
- ✅ Marketplace for user-to-user selling
- ✅ Admin dashboard for store management

---

## 2. Project Overview

### 2.1 Problem Statement

Afghanistan lacks a comprehensive local e-commerce solution that:
- Supports local languages (Dari and Pashto)
- Works reliably with limited internet connectivity
- Connects local shopkeepers with customers
- Provides cash-on-delivery payment options

### 2.2 Solution

Zakaz-AF addresses these challenges by providing:
- A user-friendly mobile app with RTL (Right-to-Left) support
- Offline-first architecture for poor connectivity areas
- Direct communication between buyers and sellers
- Multiple payment options including cash on delivery
- A marketplace for peer-to-peer selling

### 2.3 Target Audience

| User Type | Description |
|-----------|-------------|
| **Customers** | Afghan residents looking to shop online |
| **Shop Owners** | Local Afghan shopkeepers wanting to sell online |
| **Marketplace Sellers** | Individuals wanting to sell used/new items |
| **Administrators** | Platform managers and moderators |

---

## 3. Technical Architecture

### 3.1 System Architecture

```
┌─────────────────┐     HTTPS      ┌─────────────────┐
│                 │ ◄────────────► │                 │
│  Flutter App    │                │   Nginx Server  │
│  (Android)      │                │  (Reverse Proxy)│
│                 │                │                 │
└─────────────────┘                └────────┬────────┘
                                            │
                                            ▼
                                   ┌─────────────────┐
                                   │                 │
                                   │   Laravel API   │
                                   │   (PHP 8.3)     │
                                   │                 │
                                   └────────┬────────┘
                                            │
                                            ▼
                                   ┌─────────────────┐
                                   │                 │
                                   │     MySQL       │
                                   │   Database      │
                                   │                 │
                                   └─────────────────┘
```

### 3.2 Directory Structure

```
zakaz-af/
├── backend/                    # Laravel Backend
│   ├── app/
│   │   ├── Http/Controllers/   # API Controllers
│   │   ├── Models/             # Eloquent Models
│   │   └── Services/           # Business Logic
│   ├── database/
│   │   ├── migrations/         # Database Migrations
│   │   └── seeders/            # Database Seeders
│   ├── routes/
│   │   └── api.php             # API Routes
│   └── public/
│       └── download.html       # App Download Page
│
├── mobile_app/                 # Flutter Application
│   ├── lib/
│   │   ├── core/               # Core utilities
│   │   │   ├── network/        # API client (Dio)
│   │   │   ├── localization/   # Translations
│   │   │   ├── services/       # App services
│   │   │   └── widgets/        # Reusable widgets
│   │   └── features/           # Feature modules
│   │       ├── auth/           # Authentication
│   │       ├── home/           # Home screen
│   │       ├── products/       # Product catalog
│   │       ├── cart/           # Shopping cart
│   │       ├── orders/         # Order management
│   │       ├── chat/           # Real-time messaging
│   │       ├── marketplace/    # P2P marketplace
│   │       ├── profile/        # User profile
│   │       └── admin/          # Admin dashboard
│   └── android/                # Android configuration
│
└── DEV_STATUS.md               # Development status
```

---

## 4. Technology Stack

### 4.1 Mobile Application

| Technology | Version | Purpose |
|------------|---------|---------|
| Flutter | 3.x | Cross-platform UI framework |
| Dart | 3.x | Programming language |
| Riverpod | 2.x | State management |
| Dio | 5.x | HTTP client |
| Go Router | 6.x | Navigation |
| Firebase | Latest | Push notifications |
| SharedPreferences | - | Local storage |
| Cached Network Image | - | Image caching |

### 4.2 Backend

| Technology | Version | Purpose |
|------------|---------|---------|
| Laravel | 12.x | PHP Framework |
| PHP | 8.3 | Server-side language |
| MySQL | 8.0 | Database |
| Nginx | Latest | Web server |
| Composer | 2.x | Dependency management |
| Laravel Sanctum | - | API authentication |

### 4.3 Infrastructure

| Component | Provider | Details |
|-----------|----------|---------|
| VPS Server | VPSDime | Ubuntu 24.04 LTS |
| Domain | Namecheap | zakaz-af.store |
| SSL Certificate | Let's Encrypt | Auto-renewal enabled |
| Code Repository | GitHub | Private repository |
| APK Hosting | GitHub Releases | Free hosting |

---

## 5. Mobile Application Features

### 5.1 Authentication Module

| Feature | Description |
|---------|-------------|
| Email/Password Login | Traditional authentication |
| Google Sign-In | OAuth 2.0 integration |
| OTP Verification | Phone number verification |
| Password Reset | Email-based recovery |
| Guest Mode | Browse without account |
| Token Refresh | Automatic session renewal |

### 5.2 Product Catalog

| Feature | Description |
|---------|-------------|
| Category Browsing | Organized product categories |
| Product Search | Full-text search capability |
| Product Details | Images, description, reviews |
| Wishlist | Save favorite products |
| Product Reviews | Star ratings and comments |
| Sort & Filter | Price, popularity, rating |

### 5.3 Shopping Cart

| Feature | Description |
|---------|-------------|
| Add/Remove Items | Cart management |
| Quantity Adjustment | Update item quantities |
| Price Calculation | Real-time total updates |
| Multi-shop Checkout | Combined orders |
| Saved Cart | Persistent across sessions |

### 5.4 Order Management

| Feature | Description |
|---------|-------------|
| Order Placement | Complete checkout flow |
| Order Tracking | Real-time status updates |
| Order History | View past orders |
| Order Details | Full order information |
| Push Notifications | Status change alerts |

### 5.5 Chat System

| Feature | Description |
|---------|-------------|
| Buyer-Seller Chat | Direct messaging |
| Marketplace Chat | P2P communication |
| Image Sharing | Send photos in chat |
| Message Notifications | Real-time alerts |
| Conversation List | All active chats |

### 5.6 Marketplace (P2P)

| Feature | Description |
|---------|-------------|
| Create Listing | Sell personal items |
| Edit/Delete Listing | Manage your listings |
| Image Upload | Multiple photos per listing |
| Contact Seller | In-app messaging |
| Listing Categories | Organized browsing |

### 5.7 User Profile

| Feature | Description |
|---------|-------------|
| Profile Management | Edit personal info |
| Address Book | Multiple delivery addresses |
| Notification Settings | Customize alerts |
| Language Selection | EN, Dari, Pashto |
| Theme Selection | Light/Dark mode |
| Help Center | FAQ and support |
| About | App information |
| Privacy Policy | Legal information |
| Terms of Use | User agreements |

### 5.8 Admin Features

| Feature | Description |
|---------|-------------|
| Dashboard | Sales overview |
| Product Management | Add/edit/delete products |
| Category Management | Organize categories |
| Order Management | Process orders |
| User Management | Manage customers |
| Shop Settings | Configure store |

---

## 6. Backend API

### 6.1 API Endpoints

#### Authentication
```
POST   /api/auth/register          # User registration
POST   /api/auth/login             # User login
POST   /api/auth/google            # Google OAuth
POST   /api/auth/logout            # User logout
POST   /api/auth/refresh           # Refresh token
POST   /api/auth/forgot-password   # Password reset request
POST   /api/auth/reset-password    # Password reset
POST   /api/auth/verify-otp        # OTP verification
```

#### Products
```
GET    /api/products               # List products
GET    /api/products/{id}          # Product details
POST   /api/products               # Create product (admin)
PUT    /api/products/{id}          # Update product (admin)
DELETE /api/products/{id}          # Delete product (admin)
GET    /api/products/search        # Search products
```

#### Categories
```
GET    /api/categories             # List categories
GET    /api/categories/{id}        # Category details
POST   /api/categories             # Create category (admin)
PUT    /api/categories/{id}        # Update category (admin)
DELETE /api/categories/{id}        # Delete category (admin)
```

#### Cart
```
GET    /api/cart                   # Get user's cart
POST   /api/cart                   # Add to cart
PUT    /api/cart/{id}              # Update cart item
DELETE /api/cart/{id}              # Remove from cart
DELETE /api/cart                   # Clear cart
```

#### Orders
```
GET    /api/orders                 # List user's orders
GET    /api/orders/{id}            # Order details
POST   /api/orders                 # Create order
PUT    /api/orders/{id}/status     # Update order status
```

#### Marketplace
```
GET    /api/marketplace            # List marketplace items
GET    /api/marketplace/{id}       # Item details
POST   /api/marketplace            # Create listing
PUT    /api/marketplace/{id}       # Update listing
DELETE /api/marketplace/{id}       # Delete listing
GET    /api/marketplace/my-items   # User's listings
```

#### Chat
```
GET    /api/conversations          # List conversations
GET    /api/conversations/{id}     # Conversation messages
POST   /api/conversations          # Start conversation
POST   /api/messages               # Send message
```

#### User
```
GET    /api/user                   # Current user profile
PUT    /api/user                   # Update profile
PUT    /api/user/fcm-token         # Update FCM token
GET    /api/addresses              # List addresses
POST   /api/addresses              # Add address
PUT    /api/addresses/{id}         # Update address
DELETE /api/addresses/{id}         # Delete address
```

#### Wishlist
```
GET    /api/wishlist               # Get wishlist
POST   /api/wishlist               # Add to wishlist
DELETE /api/wishlist/{id}          # Remove from wishlist
```

#### Reviews
```
GET    /api/products/{id}/reviews  # Product reviews
POST   /api/products/{id}/reviews  # Add review
```

#### App Settings
```
GET    /api/app-settings           # Get app configuration
```

### 6.2 API Response Format

```json
{
    "success": true,
    "message": "Operation successful",
    "data": {
        // Response data
    }
}
```

### 6.3 Error Response Format

```json
{
    "success": false,
    "message": "Error description",
    "errors": {
        "field": ["Validation error message"]
    }
}
```

---

## 7. Database Design

### 7.1 Entity Relationship Diagram

```
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│    users     │       │   products   │       │  categories  │
├──────────────┤       ├──────────────┤       ├──────────────┤
│ id           │       │ id           │       │ id           │
│ name         │       │ name         │       │ name         │
│ email        │       │ description  │       │ image        │
│ password     │       │ price        │       │ parent_id    │
│ role         │       │ category_id  │◄──────│ created_at   │
│ fcm_token    │       │ shop_id      │       └──────────────┘
│ profile_image│       │ stock        │
│ created_at   │       │ images       │
└──────┬───────┘       │ created_at   │
       │               └──────┬───────┘
       │                      │
       ▼                      ▼
┌──────────────┐       ┌──────────────┐
│   orders     │       │    shops     │
├──────────────┤       ├──────────────┤
│ id           │       │ id           │
│ user_id      │       │ name         │
│ status       │       │ description  │
│ total        │       │ owner_id     │
│ address_id   │       │ logo         │
│ payment_type │       │ created_at   │
│ created_at   │       └──────────────┘
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ order_items  │
├──────────────┤
│ id           │
│ order_id     │
│ product_id   │
│ quantity     │
│ price        │
└──────────────┘
```

### 7.2 Database Tables

| Table | Description | Records |
|-------|-------------|---------|
| users | User accounts | Dynamic |
| categories | Product categories | ~20 |
| products | Store products | Dynamic |
| product_images | Product photos | Dynamic |
| shops | Store information | Dynamic |
| orders | Customer orders | Dynamic |
| order_items | Order line items | Dynamic |
| addresses | Delivery addresses | Dynamic |
| wishlists | User favorites | Dynamic |
| reviews | Product reviews | Dynamic |
| conversations | Chat threads | Dynamic |
| messages | Chat messages | Dynamic |
| marketplace_items | P2P listings | Dynamic |
| marketplace_item_images | P2P listing photos | Dynamic |
| notifications | Push notifications | Dynamic |
| app_settings | App configuration | ~10 |
| cache | Laravel cache | Dynamic |
| sessions | User sessions | Dynamic |
| jobs | Background tasks | Dynamic |

---

## 8. Security Implementation

### 8.1 Authentication Security

| Feature | Implementation |
|---------|----------------|
| Password Hashing | Bcrypt (12 rounds) |
| Token Authentication | Laravel Sanctum |
| Token Expiration | 30 days |
| Automatic Refresh | On 401 response |
| Google OAuth | Secure OAuth 2.0 |

### 8.2 API Security

| Feature | Implementation |
|---------|----------------|
| HTTPS | SSL/TLS encryption |
| CORS | Configured for mobile app |
| Rate Limiting | Laravel rate limiter |
| Input Validation | Request validation |
| SQL Injection | Eloquent ORM protection |
| XSS Prevention | Response sanitization |

### 8.3 Mobile App Security

| Feature | Implementation |
|---------|----------------|
| Secure Storage | SharedPreferences (encrypted) |
| Certificate Pinning | Optional (future) |
| Obfuscation | ProGuard enabled |
| Biometric Auth | Optional (future) |

### 8.4 Server Security

| Feature | Implementation |
|---------|----------------|
| Firewall | UFW (Nginx, SSH only) |
| SSH Access | Key-based (recommended) |
| Database | Local access only |
| File Permissions | Proper ownership |
| SSL Certificate | Let's Encrypt (auto-renewal) |

---

## 9. Deployment Infrastructure

### 9.1 Server Specifications

| Component | Specification |
|-----------|---------------|
| Provider | VPSDime |
| OS | Ubuntu 24.04 LTS |
| IP Address | 185.197.31.25 |
| Storage | SSD |
| Bandwidth | Unmetered |

### 9.2 Software Stack

| Software | Version | Status |
|----------|---------|--------|
| Nginx | Latest | ✅ Running |
| PHP | 8.3 | ✅ Running |
| PHP-FPM | 8.3 | ✅ Running |
| MySQL | 8.0 | ✅ Running |
| Composer | 2.x | ✅ Installed |
| Certbot | Latest | ✅ Installed |
| Git | Latest | ✅ Installed |

### 9.3 Domain Configuration

| Domain | Purpose | SSL |
|--------|---------|-----|
| zakaz-af.store | Main website | ✅ |
| api.zakaz-af.store | API endpoint | ✅ |
| www.zakaz-af.store | WWW redirect | ✅ |

### 9.4 Nginx Configuration

```nginx
server {
    listen 443 ssl;
    server_name zakaz-af.store www.zakaz-af.store api.zakaz-af.store;
    root /var/www/zakaz-af/backend/public;
    
    ssl_certificate /etc/letsencrypt/live/zakaz-af.store/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/zakaz-af.store/privkey.pem;
    
    index index.php;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

### 9.5 Deployment Process

1. **Code Push** - Developer pushes to GitHub
2. **Server Pull** - Run `git pull` on server
3. **Dependencies** - Run `composer install --no-dev`
4. **Migrations** - Run `php artisan migrate --force`
5. **Cache Clear** - Run `php artisan config:clear`
6. **Restart** - Restart PHP-FPM if needed

---

## 10. Localization & Internationalization

### 10.1 Supported Languages

| Language | Code | Direction | Status |
|----------|------|-----------|--------|
| English | en | LTR | ✅ Complete |
| Dari (Persian) | fa | RTL | ✅ Complete |
| Pashto | ps | RTL | ✅ Complete |

### 10.2 Translation Coverage

- **Authentication screens** - 100%
- **Home screen** - 100%
- **Product screens** - 100%
- **Cart & Checkout** - 100%
- **Orders** - 100%
- **Profile** - 100%
- **Chat** - 100%
- **Marketplace** - 100%
- **Admin** - 100%
- **Error messages** - 100%

### 10.3 RTL Support

- Complete mirror layout for RTL languages
- Proper text alignment
- Correct icon placement
- Appropriate font rendering

---

## 11. User Roles & Permissions

### 11.1 Role Hierarchy

```
Admin
  └── Shop Owner
        └── Customer
              └── Guest
```

### 11.2 Permissions Matrix

| Feature | Guest | Customer | Shop Owner | Admin |
|---------|-------|----------|------------|-------|
| Browse Products | ✅ | ✅ | ✅ | ✅ |
| View Product Details | ✅ | ✅ | ✅ | ✅ |
| Add to Cart | ❌ | ✅ | ✅ | ✅ |
| Place Orders | ❌ | ✅ | ✅ | ✅ |
| View Order History | ❌ | ✅ | ✅ | ✅ |
| Chat with Seller | ❌ | ✅ | ✅ | ✅ |
| Create Marketplace Listing | ❌ | ✅ | ✅ | ✅ |
| Write Reviews | ❌ | ✅ | ✅ | ✅ |
| Manage Own Shop | ❌ | ❌ | ✅ | ✅ |
| Add Products to Shop | ❌ | ❌ | ✅ | ✅ |
| View Shop Orders | ❌ | ❌ | ✅ | ✅ |
| Access Admin Dashboard | ❌ | ❌ | ❌ | ✅ |
| Manage All Products | ❌ | ❌ | ❌ | ✅ |
| Manage Categories | ❌ | ❌ | ❌ | ✅ |
| Manage Users | ❌ | ❌ | ❌ | ✅ |
| View All Orders | ❌ | ❌ | ❌ | ✅ |

---

## 12. Cost Analysis

### 12.1 Monthly Costs

| Item | Cost | Notes |
|------|------|-------|
| VPS Hosting | $5.00 | VPSDime |
| Domain | $0.17 | $2/year ÷ 12 |
| SSL Certificate | $0.00 | Let's Encrypt (free) |
| GitHub | $0.00 | Free tier |
| Firebase | $0.00 | Free tier |
| **Total** | **$5.17** | Per month |

### 12.2 Annual Costs

| Item | Cost |
|------|------|
| VPS Hosting | $60.00 |
| Domain Renewal | $2.00 |
| **Total** | **$62.00** |

### 12.3 Development Costs

| Item | Estimated Hours | Value |
|------|-----------------|-------|
| Mobile App Development | 200+ | - |
| Backend Development | 100+ | - |
| UI/UX Design | 50+ | - |
| Testing | 30+ | - |
| Deployment | 10+ | - |
| **Total** | **390+** | - |

---

## 13. Future Enhancements

### 13.1 Short-term (1-3 months)

| Feature | Priority | Status |
|---------|----------|--------|
| iOS App | High | Planned |
| Email Notifications | Medium | Planned |
| SMS Notifications | Medium | Planned |
| Payment Gateway Integration | High | Planned |
| Advanced Analytics | Medium | Planned |

### 13.2 Medium-term (3-6 months)

| Feature | Priority | Status |
|---------|----------|--------|
| Seller Dashboard Web App | High | Planned |
| Inventory Management | Medium | Planned |
| Promotional Codes | Medium | Planned |
| Flash Sales | Low | Planned |
| Product Recommendations | Medium | Planned |

### 13.3 Long-term (6-12 months)

| Feature | Priority | Status |
|---------|----------|--------|
| Multi-vendor Marketplace | High | Planned |
| Delivery Tracking GPS | High | Planned |
| AI-powered Search | Medium | Planned |
| Voice Search | Low | Planned |
| Augmented Reality Preview | Low | Planned |

---

## 14. Conclusion

Zakaz-AF represents a significant step forward in bringing e-commerce capabilities to the Afghan market. The platform successfully addresses the unique challenges of the region including:

- **Language barriers** - Full support for English, Dari, and Pashto
- **Limited connectivity** - Efficient data usage and caching
- **Payment preferences** - Cash on delivery option
- **Local focus** - Connecting local shopkeepers with customers

The technical implementation follows modern best practices:
- Clean architecture with separation of concerns
- Secure API with proper authentication
- Scalable infrastructure with room for growth
- Comprehensive feature set for all user types

With the successful deployment of the production environment, Zakaz-AF is ready to serve the Afghan e-commerce market and has the foundation for future growth and enhancement.

---

## Appendix

### A. Admin Credentials

| Field | Value |
|-------|-------|
| Email | khairullahanosh9626@gmail.com |
| Role | Admin |

### B. Server Access

| Field | Value |
|-------|-------|
| IP | 185.197.31.25 |
| SSH | `ssh root@185.197.31.25` |

### C. Database

| Field | Value |
|-------|-------|
| Type | MySQL 8.0 |
| Database | zakaz_db |
| User | zakaz_user |

### D. Important URLs

| URL | Purpose |
|-----|---------|
| https://zakaz-af.store | Main domain |
| https://zakaz-af.store/download.html | APK download page |
| https://api.zakaz-af.store/api | API endpoint |
| https://github.com/KhairullahChakir/zakaz-af | Source code |

### E. APK Information

| Field | Value |
|-------|-------|
| Package ID | com.zakaz.af |
| Version | 1.0.0 |
| Min Android | 7.0 (API 24) |
| Target Android | 14 (API 36) |
| Size | ~80 MB |
| Signed | Yes (Release key) |

---

**Report Generated:** January 2, 2026  
**Author:** Antigravity AI Assistant  
**Project Developer:** Khairullah Chakir

---

*© 2026 Zakaz-AF. All rights reserved.*
