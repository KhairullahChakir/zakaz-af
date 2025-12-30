# Zakaz-AF: The Cross-Border Marketplace for Afghanistan
**Project Report & Feature Analysis**

**Date:** 2025-12-25
**Concept:** "Remittance-via-Goods" Marketplace

---

## 1. Core Concept
**Zakaz-AF** operates as a multi-vendor marketplace, but its primary strategic focus is serving the **Afghan Diaspora**. It allows Afghans living abroad (USA, Europe, UAE, etc.) to purchase goods—groceries, appliances, gifts—directly from local Afghan shopkeepers and have them delivered to their families in Afghanistan.

This model shifts the paradigm from **sending cash** (which can be misused or difficult to collect) to **sending care** (actual products/necessities).

---

## 2. User Roles & Workflows

### 🌍 A. The Sender (Global Start Point)
*Profile: Afghan expatriate living abroad with disposable income.*

*   **Global Access:** The app is accessible globally, allowing registration with international phone numbers or email.
*   **Curated Marketplace:** Users browse products listed by local Afghan shopkeepers.
    *   *Usage:* Buying a monthly sack of rice/flour (Rashan) for parents in Kabul.
    *   *Usage:* Buying a new phone or clothes for a sibling's wedding.
*   **"Recipient" Management:** Unlike a normal e-commerce app where you buy for yourself, this app features a robust **Recipient Address Book**.
    *   The Sender saves "Mom's House" or "Brother's Office" as contacts with local Afghan phone numbers.
*   **The Trust Layer (Payment):**
    *   **Integration:** **HesabPay**. This is the critical bridge. It allows the Sender to pay securely using funds linked to the Afghan banking ecosystem or international cards supported by the gateway.
    *   **Currency View:** Prices are fixed in AFN by sellers but can be displayed in approx USD/EUR for the Sender's convenience.

### 🏠 B. The Recipient (Local End Point)
*Profile: Family members living in Afghanistan.*

*   **Passive Interaction:** They do not necessarily need the smartphone app. They primarily interact via **SMS** and **Phone Calls**.
*   **Verification:** Upon delivery, they may provide a secure **OTP (One-Time Password)** sent to their mobile number to confirm they are the intended recipient.
*   **Feedback Loop:** They receive the goods, and the "Digital Proof" (photo/signature) is sent back to the Sender.

### 🏪 C. The Shopkeeper (Vendor)
*Profile: Local business owner in Kabul/Herat/etc.*

*   **Inventory Management:** Lists products available in their physical store.
*   **Order Fulfillment:** Receives an order stating "Package ordered by Ahmad (in London) for recipient Wali (in Kabul)."
*   **Settlement:** Receives payouts from Zakaz-AF (after the platform takes a commission) for the confirmed deliveries.

---

## 3. Key Feature Analysis

### 💳 Payment & Finance (HesabPay)
*   **Direct & Secure:** Uses HesabPay to process transactions. This builds immediate trust as HesabPay is a recognized financial entity in the region.
*   **Settlement Flow:**
    1.  Sender pays via HesabPay (Money -> Zakaz Escrow).
    2.  Product Delivered.
    3.  Zakaz releases funds to Shopkeeper wallet.

### 🎁 Gifting & Occasions
Since the primary driver is "Care/connection":
*   **Gift Wrapping Options:** The user can check "Gift Wrap" during checkout.
*   **Personal Notes:** Sender types a message ("Happy Birthday Mom"), which is printed or written on a card included with the delivery.
*   **Event Bundles:** Special "Eid Packages" or "Wedding Season" bundles pre-curated to make selection easy for someone disconnected from local daily trends.

---

## 4. Logistics & Delivery Models
*The "Shopkeeper vs. Agent" Strategy*

To support the "High Trust" requirement of diaspora users, the platform supports a Hybrid Logistics Model:

### Model A: "Fulfilled by Shopkeeper" (Standard)
*   **Usage:** For low-value or non-fragile items (e.g., bulk rice, flour).
*   **Process:** The shopkeeper uses their own delivery boy/runner.
*   **Pros:** Lower cost, faster for neighborhood deliveries.
*   **Cons:** Variable service quality.
*   **Feature:** User pays a standard delivery fee. Status updates rely on the Shopkeeper clicking "Delivered."

### Model B: "Zakaz Trusted Delivery" (Agent)
*   **Usage:** For high-value items (Electronics, Jewelry) or "Experience" gifts (Flowers, Cakes).
*   **Process:** A uniformed Zakaz-AF Agent picks up the item from the shop, verifies its quality/packaging, and delivers it to the family.
*   **Pros:**
    *   **Quality Check:** Agent ensures the iPhone is sealed or the cake isn't smashed *before* delivery.
    *   **Premium Experience:** Agent handles the "Gift Note" reading or professional photo proof.
*   **Feature:** This functions as a "Premium Shipping" option in checkout.

---

## 5. Summary of "Research Features"
*For your deep research, focus on these unique selling points:*

1.  **Cross-Border Address Book:** Decoupling the "Billing User" from the "Shipping User."
2.  **HesabPay Trust Chain:** How using a known payment gateway legitimizes the platform for wary overseas buyers.
3.  **Digital Verification for Physical Goods:** Using OTPs and Photo-Proof to close the loop between a sender in London and a recipient in Kabul.
4.  **Hybrid Logistics:** Offering tiered delivery (Standard vs. Trusted Agent) to balance operational scale with quality assurance.
