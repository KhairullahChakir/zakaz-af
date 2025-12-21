# Zakaz - AF Development Status

## Project Overview
**Zakaz-AF** is a multi-vendor e-commerce marketplace for Afghanistan, connecting customers with local shopkeepers.

## User Roles
| Role | Description |
|------|-------------|
| **Customer** | Browse products, place orders, track deliveries |
| **Shopkeeper** | Manage their shop, add products, handle orders |
| **Admin** | Approve shops, manage platform, view analytics |

## Completed Features

### 1. Backend & Database
- **Stack**: Laravel + MariaDB
- **Tables**: Users, Categories, Products, Orders, OrderItems, Reviews, Addresses, Wishlists, Shops
- **Seed Data**: Sample products and categories
- **API**: RESTful endpoints for all features

### 2. Authentication & Users
- Login/Register with phone/email
- Profile management (name, email, phone, profile image)
- Role-based access: `customer`, `shopkeeper`, `admin`
- Token-based auth with Sanctum

### 3. Customer Features
- **Home Screen**: Category filter, product grid, pull-to-refresh
- **Product Search**: Real-time search with search history
- **Product Sorting**: By newest, price, rating, popularity
- **Product Details**: Images, description, reviews, add to cart
- **Wishlist**: Save favorite products with heart button
- **Cart**: Persistent cart with quantity management
- **Checkout**: Address selection, order summary, place order
- **Order History**: Past orders with status tracking
- **Order Tracking**: Visual timeline for order status
- **Reviews**: Read and post ratings/comments
- **Address Management**: Full CRUD with default address
- **Dark Mode**: Theme toggle in drawer

### 4. Shopkeeper Features (NEW)
- **Become a Shopkeeper**: Multi-step application form
  - Shop info: name, type, description, photos (1-3)
  - Location: address, city, province, GPS
  - Documents: business license, owner NID (Tazkira)
- **Shopkeeper Dashboard**:
  - Stats: products, orders, revenue, pending orders
  - Quick actions: add product, view orders
  - Recent orders preview
- **Product Management**: Add/edit/delete own products
- **Order Management**: View and update order status

### 5. Admin Features
- **Analytics Dashboard**: Revenue, top products, recent sales
- **Product Management**: Full CRUD for all products
- **Category Management**: Add/edit/delete categories
- **Shop Applications** (NEW):
  - View pending/approved/rejected/suspended shops
  - Review application details and documents
  - Approve, reject (with reason), or suspend shops

### 6. Technical Features
- **Auth Interceptor**: Auto-inject Bearer token in all requests
- **Cart Persistence**: SharedPreferences for offline cart
- **FCM Infrastructure**: Push notification ready
- **Image Upload**: Profile, products, shop photos, documents
- **Riverpod**: State management with code generation
- **GoRouter**: Declarative routing

## API Endpoints

### Public
- `GET /categories`, `GET /products`, `GET /products/{id}`

### Auth
- `POST /register`, `POST /login`, `POST /logout`
- `GET /user`, `POST /user/profile`

### Customer
- `POST /orders`, `GET /orders`, `GET /orders/{id}`
- `GET/POST /reviews`, `GET/POST/DELETE /wishlist`
- `GET/POST/PUT/DELETE /addresses`

### Shopkeeper
- `GET /shopkeeper/dashboard`
- `GET/POST /shopkeeper/products`, `POST/DELETE /shopkeeper/products/{id}`
- `GET /shopkeeper/orders`, `PATCH /shopkeeper/orders/{id}/status`

### Shop Application
- `POST /shop/apply`, `GET /shop/status`

### Admin
- `GET /analytics/stats`
- `GET/POST /admin/products`, `POST/DELETE /admin/products/{id}`
- `POST /admin/categories`, `POST/DELETE /admin/categories/{id}`
- `GET /admin/shops`, `GET /admin/shops/pending`
- `POST /admin/shops/{id}/approve`, `POST /admin/shops/{id}/reject`
- `POST /admin/shops/{id}/suspend`

## Next Steps
1. **Testing**: Unit tests for repositories and controllers
2. **Payment Integration**: Payment gateway for checkout
3. **Notifications**: Push notifications for order updates
4. **Coupons/Discounts**: Promo codes at checkout
5. **Multi-language**: Dari/Pashto/English support
6. **Location Services**: GPS-based shop discovery

## Tech Stack
- **Backend**: Laravel 11, MariaDB, Sanctum
- **Mobile**: Flutter 3.x, Riverpod, GoRouter, Dio
- **Storage**: Laravel Storage (local), SharedPreferences
