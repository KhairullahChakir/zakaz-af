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
        *   **Product Sorting**: Added ability to sort products by newest, price low to high, and price high to low.
        *   **Address Management**: Full CRUD for delivery addresses with default selection.
        *   **Notifications**: Infrastructure for FCM push notifications integrated.
    *   **Fixes**:
        *   **Auth Header**: `Authorization: Bearer <token>` is now automatically injected into ALL requests via a Dio Interceptor.
        *   **Cart Persistence**: Implemented `SharedPreferences` to save cart items to disk. Cart items now survive app restarts!
    *   **Polish**:
        *   **Cart Badge**: Visual indicator on the shopping cart icon showing the number of items.
        *   **Pull-to-refresh**: Added to Home Screen for categories and products.
        *   **Side Drawer**: Premium navigation menu with Home, Profile, Order History, Addresses, and Logout.
        *   **Order History Screen**: Users can now view their past orders, including status and line items.
        *   **Real User Data**: Home screen drawer now displays the logged-in user's name and email.

## Next Steps
1.  **Analytics**: Basic admin dashboard for sales.
2.  **Dark Mode**: Support system dark theme.
3.  **Search History**: Save recent searches.
4.  **Unit Tests**: Improve code coverage.
