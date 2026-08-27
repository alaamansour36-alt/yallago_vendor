# Alignment with the supplied 12-week MVP plan

The submitted plan defines a four-app delivery MVP supported by a modular ASP.NET Core monolith. This Flutter source package deliberately implements only the **Customer App and Vendor App**, matching the approved product-design brief. Driver and Admin source is not included and should be built as separate apps when their product specifications are approved.

The current client app uses local sample state so the mobile team can validate navigation and customer/vendor experience before backend availability. The exact areas intended for live API integration are OTP authentication, vendor/menu discovery, order creation, order history/status, vendor menu changes, and vendor order state updates.

| Plan priority | Flutter implementation status | Future integration |
|---|---|---|
| App shell, bilingual UI, navigation and design tokens | Implemented | No backend dependency. |
| OTP UI | Implemented as local simulation | `POST /auth/send-otp`, `POST /auth/verify-otp`. |
| Restaurant browsing and menu | Implemented with sample data | `GET /vendors`, `GET /vendors/{id}/menu`. |
| Cash-on-delivery checkout | Implemented as visual flow | `POST /orders`. |
| Customer order status/history | Implemented as sample state | `GET /orders/customer`, polling or WebSocket status updates. |
| Vendor menu management | Implemented as local editor/toggles | `POST /vendors/{id}/menu`, `PUT /menu/{id}`. |
| Vendor order lifecycle | Implemented through Accepted → Preparing → Ready | `GET /orders/vendor`, `PUT /orders/{id}/status`. |

For production, retain the modular boundaries described in the plan. Mobile code should inject repositories behind feature-specific interfaces rather than placing HTTP calls directly in widgets.
