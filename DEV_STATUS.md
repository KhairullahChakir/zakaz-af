# Zakaz - AF Development Status

## Completed Steps
1.  **Backend & DB**:
    *   Setup complete (MariaDB, Users, Categories, Products).
    *   **Seed Data**: Populated with sample products.
    *   **API**: Active.
    *   **Orders**: `orders` and `order_items` tables created, `OrderController` implemented.
2.  **Mobile App Foundation**:
    *   **Auth**: Login/Register, Persistence, Logout.
    *   **UI**: 
        *   Home Screen with Category Filter.
        *   Product Details Screen active.
        *   Cart Screen (View items, update quantity, total).
    *   **Features Integrated**:
        *   Add to Cart -> Show Snackbar.
        *   View Cart -> Cart Badge/Icon navigation.
        *   **Checkout**: "Place Order" button connects to backend, saves order, and clears cart.
        *   **Search**: Real-time product search by name and description in the Home Screen.
        *   **Reviews**: Users can read and post ratings/comments for each product.
        *   **Profile**: Users can now edit their Name, Email, Phone number, and Profile Image.
        *   **Product Sorting**: Added ability to sort products by newest, price, rating, and popularity.
        *   **Address Management**: Full CRUD for delivery addresses with default selection.
        *   **Notifications**: Infrastructure for FCM push notifications integrated.
        *   **Analytics**: Admin dashboard with revenue, top products, and recent sales view.
        *   **Dark Mode**: Theme toggle in drawer with full system/light/dark support.
        *   **Search History**: Recent searches saved locally and displayed in search mode.
        *   **Checkout Polish**: Full checkout screen with address selection, order summary, and place order flow.
        *   **Wishlist**: Save favorite products with heart button on product details and dedicated wishlist screen.
        *   **Order Tracking**: Visual timeline for order status, detailed order view, and admin status updates.
    *   **Fixes**:
        *   **Auth Header**: `Authorization: Bearer <token>` is now automatically injected into ALL requests via a Dio Interceptor.
        *   **Cart Persistence**: Implemented `SharedPreferences` to save cart items to disk. Cart items now survive app restarts!
    *   **Polish**:
        *   **Cart Badge**: Visual indicator on the shopping cart icon showing the number of items.
        *   **Pull-to-refresh**: Added to Home Screen for categories and products.
        *   **Side Drawer**: Premium navigation with Wishlist, Profile, Order History, Addresses, Admin Dashboard, and Dark Mode.
        *   **Order History Screen**: Users can now view their past orders, including status and line items.
        *   **Real User Data**: Home screen drawer now displays the logged-in user's name and email.

## Next Steps
1.  **Unit Tests**: Improve code coverage for repositories and controllers.
2.  **Admin UI**: Full product and category management via the app.
3.  **Coupons**: Discount codes at checkout.
4.  **Stock Management**: Product stock tracking and low-stock alerts.
