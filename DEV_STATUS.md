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
    *   **Fixes**:
        *   **Auth Header**: `Authorization: Bearer <token>` is now automatically injected into ALL requests via a Dio Interceptor.
        *   **Cart Persistence**: Implemented `SharedPreferences` to save cart items to disk. Cart items now survive app restarts!
    *   **Polish**:
        *   **Cart Badge**: Visual indicator on the shopping cart icon showing the number of items.
        *   **Pull-to-refresh**: Added to Home Screen for categories and products.
        *   **Side Drawer**: Premium navigation menu with Home, Order History, and Logout.
        *   **Order History Screen**: Users can now view their past orders, including status and line items.
        *   **Real User Data**: Home screen drawer now displays the logged-in user's name and email.

## Next Steps
1.  **Search**: Implement product search functionality.
2.  **Product Reviews**: Allow users to rate and review products.
3.  **Refined Profile**: Edit profile information (Name, Phone).
