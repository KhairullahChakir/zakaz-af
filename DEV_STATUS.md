# Zakaz - AF Development Status

## Completed Steps
1.  **Backend & DB**:
    *   Setup complete (MariaDB, Users, Categories, Products).
    *   **Seed Data**: Populated with sample products.
    *   **API**: Active.
2.  **Mobile App Foundation**:
    *   **Auth**: Login/Register, Persistence, Logout.
    *   **UI**: 
        *   Home Screen with Category Filter.
        *   Product Details Screen active.
        *   Cart Screen (View items, update quantity, total).
    *   **Features Integrated**:
        *   Add to Cart -> Show Snackbar.
        *   View Cart -> Cart Badge/Icon navigation.
    *   **Fixes**:
        *   **Cart Persistence**: Enabled `keepAlive` on `cartProvider` so items don't disappear when navigating away.

## Next Steps
1.  **Checkout**: (Future) Implement order placement.
2.  **Polish**: Show "Cart Badge" (number of items) on the cart icon.
