# YallaGo API Reference

This file documents the current backend API surface for frontend integration.

Base path:
- `/api`

Authentication header for protected endpoints:
```http
Authorization: Bearer {token}
```

Roles used by the API:
- Customer
- Vendor

---

## 1. Common Response Wrapper

Most endpoints return the application wrapper below:

```json
{
   "success": true,
   "message": "optional message",
   "data": {}
}
```

Generic shape:

```json
{
   "success": "boolean",
   "message": "string",
   "data": "T | null"
}
```

Notes:
- On failure, `success` is `false` and `data` is usually `null`.
- Some endpoints return `404`, `400`, `401`, `403`, or `409` depending on the controller logic.
- `POST /api/cart/items` has a custom `409 Conflict` body for the one-market cart rule.

### 1.1 Paged data shape

Endpoints that return paged results use this inside `data`:

```json
{
   "data": [],
   "pagination": {
      "page": 1,
      "pageSize": 10,
      "totalCount": 0,
      "totalPages": 0
   }
}
```

---

## 2. Authentication APIs

Controller:
- `/api/authentication`

### 2.1 Get all customers

- Method: `GET`
- URL: `/api/authentication/customers`
- Auth: currently no `[Authorize]` on action

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Customers retrieved successfully",
   "data": [
      {
         "id": "GUID",
         "applicationUserId": "string",
         "fullName": "Ahmed Ali",
         "email": "customer@example.com",
         "phoneNumber": "01000000000",
         "address": "Nasr City, Cairo",
         "defaultDeliveryAddress": "Nasr City, Cairo",
         "preferredContactNumber": "01000000000"
      }
   ]
}
```

Response `data` item shape:
```json
{
   "id": "guid",
   "applicationUserId": "string",
   "fullName": "string",
   "email": "string",
   "phoneNumber": "string | null",
   "address": "string | null",
   "defaultDeliveryAddress": "string | null",
   "preferredContactNumber": "string | null"
}
```

### 2.2 Get all vendors

- Method: `GET`
- URL: `/api/authentication/vendors`
- Auth: currently no `[Authorize]` on action

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Vendors retrieved successfully",
   "data": [
      {
         "id": "GUID",
         "applicationUserId": "string",
         "fullName": "Vendor Owner",
         "email": "vendor@example.com",
         "phoneNumber": "01000000001",
         "address": "Cairo",
         "storeName": "Fresh Market",
         "storeDescription": "Fresh groceries",
         "businessAddress": "Abbas El Akkad",
         "logoUrl": "https://...",
         "isApproved": true
      }
   ]
}
```

Response `data` item shape:
```json
{
   "id": "guid",
   "applicationUserId": "string",
   "fullName": "string",
   "email": "string",
   "phoneNumber": "string | null",
   "address": "string | null",
   "storeName": "string",
   "storeDescription": "string | null",
   "businessAddress": "string | null",
   "logoUrl": "string | null",
   "isApproved": true
}
```

### 2.3 Login

- Method: `POST`
- URL: `/api/authentication/login`
- Auth: anonymous

Request body:
```json
{
   "email": "customer@example.com",
   "password": "P@ssw0rd123"
}
```

Request shape:
```json
{
   "email": "string",
   "password": "string"
}
```

Success response:
```json
{
   "success": true,
   "message": "Login successful",
   "data": {
      "token": "JWT_TOKEN",
      "email": "customer@example.com",
      "fullName": "Ahmed Ali",
      "roles": ["Customer"]
   }
}
```

Response `data` shape:
```json
{
   "token": "string",
   "email": "string",
   "fullName": "string",
   "roles": ["string"]
}
```

Failure response example:
```json
{
   "success": false,
   "message": "Invalid email or password",
   "data": null
}
```

### 2.4 Register customer

- Method: `POST`
- URL: `/api/authentication/register/customer`
- Auth: anonymous

Request body:
```json
{
   "fullName": "Ahmed Ali",
   "email": "customer@example.com",
   "phoneNumber": "01000000000",
   "address": "Nasr City, Cairo",
   "password": "P@ssw0rd123",
   "confirmPassword": "P@ssw0rd123",
   "defaultDeliveryAddress": "Nasr City, Cairo",
   "preferredContactNumber": "01000000000"
}
```

Request shape:
```json
{
   "fullName": "string",
   "email": "string",
   "phoneNumber": "string",
   "address": "string | null",
   "password": "string",
   "confirmPassword": "string",
   "defaultDeliveryAddress": "string | null",
   "preferredContactNumber": "string | null"
}
```

Success response:
```json
{
   "success": true,
   "message": "Customer registered successfully",
   "data": {
      "token": "JWT_TOKEN",
      "email": "customer@example.com",
      "fullName": "Ahmed Ali",
      "roles": ["Customer"]
   }
}
```

Response `data` shape:
- same as login `AuthResponseDto`

### 2.5 Register vendor

- Method: `POST`
- URL: `/api/authentication/register/vendor`
- Auth: anonymous

Request body:
```json
{
   "fullName": "Vendor Owner",
   "email": "vendor@example.com",
   "phoneNumber": "01000000001",
   "address": "Cairo",
   "password": "P@ssw0rd123",
   "confirmPassword": "P@ssw0rd123",
   "storeName": "Fresh Market",
   "storeDescription": "Fresh groceries",
   "businessAddress": "Abbas El Akkad",
   "logoUrl": "https://example.com/logo.png"
}
```

Request shape:
```json
{
   "fullName": "string",
   "email": "string",
   "phoneNumber": "string",
   "address": "string | null",
   "password": "string",
   "confirmPassword": "string",
   "storeName": "string",
   "storeDescription": "string | null",
   "businessAddress": "string | null",
   "logoUrl": "string | null"
}
```

Success response:
```json
{
   "success": true,
   "message": "Vendor registered successfully",
   "data": {
      "token": "JWT_TOKEN",
      "email": "vendor@example.com",
      "fullName": "Vendor Owner",
      "roles": ["Vendor"]
   }
}
```

Response `data` shape:
- same as login `AuthResponseDto`

---

## 3. Markets APIs

Controller:
- `/api/markets`

### 3.1 Browse markets

- Method: `GET`
- URL: `/api/markets`
- Auth: anonymous

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Markets retrieved successfully",
   "data": [
      {
         "id": "GUID",
         "name": "Fresh Market",
         "slug": "fresh-market",
         "description": "Fresh groceries",
         "logoUrl": "https://...",
         "coverImageUrl": "https://...",
         "rating": 4.5,
         "reviewCount": 120,
         "status": "Open",
         "delivery": {
            "fee": 20,
            "estimatedMinutes": 35,
            "minimumOrder": 100
         },
         "location": {
            "latitude": 30.0444,
            "longitude": 31.2357
         },
         "categories": ["Vegetables", "Fruits"]
      }
   ]
}
```

Response `data` item shape:
```json
{
   "id": "guid",
   "name": "string",
   "slug": "string",
   "description": "string | null",
   "logoUrl": "string | null",
   "coverImageUrl": "string | null",
   "rating": 0,
   "reviewCount": 0,
   "status": "string",
   "delivery": {
      "fee": 0,
      "estimatedMinutes": 0,
      "minimumOrder": 0
   },
   "location": {
      "latitude": 0,
      "longitude": 0
   },
   "categories": ["string"]
}
```

### 3.2 Open one market

- Method: `GET`
- URL: `/api/markets/{marketId}`
- Auth: anonymous

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Market retrieved successfully",
   "data": {
      "id": "GUID",
      "name": "Fresh Market",
      "slug": "fresh-market",
      "description": "Fresh groceries",
      "logoUrl": "https://...",
      "coverImageUrl": "https://...",
      "rating": 4.5,
      "reviewCount": 120,
      "status": "Open",
      "delivery": {
         "fee": 20,
         "estimatedMinutes": 35,
         "minimumOrder": 100
      },
      "location": {
         "latitude": 30.0444,
         "longitude": 31.2357
      },
      "businessAddress": "Abbas El Akkad",
      "categories": [
         {
            "id": "GUID",
            "name": "Vegetables",
            "imageUrl": "https://..."
         }
      ]
   }
}
```

Response `data` shape:
```json
{
   "id": "guid",
   "name": "string",
   "slug": "string",
   "description": "string | null",
   "logoUrl": "string | null",
   "coverImageUrl": "string | null",
   "rating": 0,
   "reviewCount": 0,
   "status": "string",
   "delivery": {
      "fee": 0,
      "estimatedMinutes": 0,
      "minimumOrder": 0
   },
   "location": {
      "latitude": 0,
      "longitude": 0
   },
   "businessAddress": "string | null",
   "categories": [
      {
         "id": "guid",
         "name": "string",
         "imageUrl": "string | null"
      }
   ]
}
```

### 3.3 Browse market products

- Method: `GET`
- URL: `/api/markets/{marketId}/products`
- Auth: anonymous
- Query params:
   - `categoryId` optional
   - `page` optional, default `1`
   - `pageSize` optional, default `20`

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Products retrieved successfully",
   "data": {
      "data": [
         {
            "id": "GUID",
            "name": "Tomatoes",
            "description": "Fresh tomatoes",
            "price": 35,
            "discountPrice": 30,
            "currency": "EGP",
            "stockQuantity": 100,
            "imageUrl": "https://...",
            "isAvailable": true,
            "vendorId": "GUID",
            "vendorStoreName": "Fresh Market",
            "categoryId": "GUID",
            "categoryName": "Vegetables"
         }
      ],
      "pagination": {
         "page": 1,
         "pageSize": 20,
         "totalCount": 1,
         "totalPages": 1
      }
   }
}
```

Response `data` shape:
- `PagedResultDto<ProductDto>`

---

## 4. Products APIs

Controller:
- `/api/products`

### 4.1 Get all products

- Method: `GET`
- URL: `/api/products`
- Auth: anonymous

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Products retrieved successfully",
   "data": [
      {
         "id": "GUID",
         "name": "Tomatoes",
         "description": "Fresh tomatoes",
         "price": 35,
         "discountPrice": 30,
         "currency": "EGP",
         "stockQuantity": 100,
         "imageUrl": "https://...",
         "isAvailable": true,
         "vendorId": "GUID",
         "vendorStoreName": "Fresh Market",
         "categoryId": "GUID",
         "categoryName": "Vegetables"
      }
   ]
}
```

Response `data` item shape:
```json
{
   "id": "guid",
   "name": "string",
   "description": "string",
   "price": 0,
   "discountPrice": 0,
   "currency": "EGP",
   "stockQuantity": 0,
   "imageUrl": "string | null",
   "isAvailable": true,
   "vendorId": "guid",
   "vendorStoreName": "string",
   "categoryId": "guid | null",
   "categoryName": "string | null"
}
```

### 4.2 Get product by id

- Method: `GET`
- URL: `/api/products/{productId}`
- Auth: anonymous

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Product retrieved successfully",
   "data": {
      "id": "GUID",
      "name": "Tomatoes",
      "description": "Fresh tomatoes",
      "price": 35,
      "discountPrice": 30,
      "currency": "EGP",
      "stockQuantity": 100,
      "imageUrl": "https://...",
      "isAvailable": true,
      "vendorId": "GUID",
      "vendorStoreName": "Fresh Market",
      "categoryId": "GUID",
      "categoryName": "Vegetables"
   }
}
```

Response `data` shape:
- `ProductDto`

### 4.3 Get my vendor products

- Method: `GET`
- URL: `/api/products/mine`
- Auth: vendor token required

Request body:
- none

Success response:
- same response shape as `GET /api/products`

### 4.4 Create product

- Method: `POST`
- URL: `/api/products`
- Auth: vendor token required

Request body:
```json
{
   "name": "Tomatoes",
   "description": "Fresh tomatoes",
   "price": 35,
   "discountPrice": 30,
   "currency": "EGP",
   "stockQuantity": 100,
   "imageUrl": "https://example.com/tomatoes.png",
   "isAvailable": true,
   "categoryId": "GUID"
}
```

Request shape:
```json
{
   "name": "string",
   "description": "string",
   "price": 0,
   "discountPrice": "number | null",
   "currency": "string",
   "stockQuantity": 0,
   "imageUrl": "string | null",
   "isAvailable": true,
   "categoryId": "guid | null"
}
```

Success response:
```json
{
   "success": true,
   "message": "Product created successfully",
   "data": {
      "id": "GUID",
      "name": "Tomatoes",
      "description": "Fresh tomatoes",
      "price": 35,
      "discountPrice": 30,
      "currency": "EGP",
      "stockQuantity": 100,
      "imageUrl": "https://example.com/tomatoes.png",
      "isAvailable": true,
      "vendorId": "GUID",
      "vendorStoreName": "Fresh Market",
      "categoryId": "GUID",
      "categoryName": "Vegetables"
   }
}
```

### 4.5 Update product

- Method: `PUT`
- URL: `/api/products/{productId}`
- Auth: vendor token required

Request body:
- same shape as create product

Success response:
- same response shape as create product

### 4.6 Delete product

- Method: `DELETE`
- URL: `/api/products/{productId}`
- Auth: vendor token required

Request body:
- none

Success response:
- same wrapped response pattern
- `data` is expected to be the deleted or affected product payload depending on service implementation

Safe frontend assumption:
```json
{
   "success": true,
   "message": "Product deleted successfully",
   "data": null
}
```

---

## 5. Categories APIs

Controller:
- `/api/categories`

### 5.1 Get my vendor categories

- Method: `GET`
- URL: `/api/categories/mine`
- Auth: vendor token required

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Categories retrieved successfully",
   "data": [
      {
         "id": "GUID",
         "name": "Vegetables",
         "imageUrl": "https://..."
      }
   ]
}
```

Response `data` item shape:
```json
{
   "id": "guid",
   "name": "string",
   "imageUrl": "string | null"
}
```

### 5.2 Get category by id

- Method: `GET`
- URL: `/api/categories/{categoryId}`
- Auth: vendor token required

Request body:
- none

Success response:
- same `CategoryDto` wrapped response as above

### 5.3 Create category

- Method: `POST`
- URL: `/api/categories`
- Auth: vendor token required

Request body:
```json
{
   "name": "Vegetables",
   "imageUrl": "https://example.com/vegetables.png"
}
```

Request shape:
```json
{
   "name": "string",
   "imageUrl": "string | null"
}
```

Success response:
```json
{
   "success": true,
   "message": "Category created successfully",
   "data": {
      "id": "GUID",
      "name": "Vegetables",
      "imageUrl": "https://example.com/vegetables.png"
   }
}
```

### 5.4 Update category

- Method: `PUT`
- URL: `/api/categories/{categoryId}`
- Auth: vendor token required

Request body:
```json
{
   "name": "Fresh Vegetables",
   "imageUrl": "https://example.com/vegetables.png"
}
```

Request shape:
- same as create category

Success response:
- same wrapped `CategoryDto` response

### 5.5 Delete category

- Method: `DELETE`
- URL: `/api/categories/{categoryId}`
- Auth: vendor token required

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Category deleted successfully",
   "data": null
}
```

---

## 6. Cart APIs

Controller:
- `/api/cart`

All cart endpoints require customer token.

### 6.1 Get current cart

- Method: `GET`
- URL: `/api/cart`

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Cart retrieved successfully",
   "data": {
      "id": "GUID",
      "market": {
         "id": "GUID",
         "name": "Fresh Market",
         "logoUrl": "https://..."
      },
      "items": [
         {
            "id": "GUID",
            "product": {
               "id": "GUID",
               "name": "Tomatoes",
               "imageUrl": "https://..."
            },
            "quantity": 2,
            "unitPrice": 35,
            "totalPrice": 70,
            "allowSubstitution": false
         }
      ],
      "summary": {
         "subtotal": 70,
         "discount": 0,
         "deliveryFee": 20,
         "serviceFee": 5,
         "total": 95,
         "currency": "EGP"
      }
   }
}
```

Response `data` shape:
```json
{
   "id": "guid",
   "market": {
      "id": "guid",
      "name": "string",
      "logoUrl": "string | null"
   },
   "items": [
      {
         "id": "guid",
         "product": {
            "id": "guid",
            "name": "string",
            "imageUrl": "string | null"
         },
         "quantity": 0,
         "unitPrice": 0,
         "totalPrice": 0,
         "allowSubstitution": true
      }
   ],
   "summary": {
      "subtotal": 0,
      "discount": 0,
      "deliveryFee": 0,
      "serviceFee": 0,
      "total": 0,
      "currency": "EGP"
   }
}
```

### 6.2 Add item to cart

- Method: `POST`
- URL: `/api/cart/items`

Request body:
```json
{
   "marketId": "GUID",
   "productId": "GUID",
   "quantity": 2
}
```

Request shape:
```json
{
   "marketId": "guid",
   "productId": "guid",
   "quantity": 0
}
```

Success response:
- same wrapped `CartResponseDto` as `GET /api/cart`

Conflict response for different market:
```json
{
   "success": false,
   "code": "DIFFERENT_MARKET",
   "message": "Your cart contains items from another market.",
   "currentCart": {
      "marketId": "GUID",
      "marketName": "Fresh Market"
   }
}
```

### 6.3 Update cart item quantity

- Method: `PATCH`
- URL: `/api/cart/items/{itemId}`

Request body:
```json
{
   "quantity": 5
}
```

Request shape:
```json
{
   "quantity": 0
}
```

Success response:
- same wrapped `CartResponseDto`

### 6.4 Remove cart item

- Method: `DELETE`
- URL: `/api/cart/items/{itemId}`

Request body:
- none

Success response:
- same wrapped `CartResponseDto` or success wrapper depending on service implementation

Safe frontend assumption:
```json
{
   "success": true,
   "message": "Item removed successfully",
   "data": null
}
```

### 6.5 Clear cart

- Method: `DELETE`
- URL: `/api/cart`

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Cart cleared successfully",
   "data": null
}
```

### 6.6 Checkout review

- Method: `POST`
- URL: `/api/cart/checkout`

Request body:
```json
{
   "deliveryAddress": "Nasr City, Abbas El Akkad, Building 10",
   "paymentMethod": "Cash",
   "couponCode": null,
   "deliveryInstructions": "Call me when you arrive",
   "items": [
      {
         "cartItemId": "GUID",
         "allowSubstitution": true
      }
   ]
}
```

Request shape:
```json
{
   "deliveryAddress": "string | null",
   "paymentMethod": "string",
   "couponCode": "string | null",
   "deliveryInstructions": "string | null",
   "items": [
      {
         "cartItemId": "guid",
         "allowSubstitution": true
      }
   ]
}
```

Success response:
```json
{
   "success": true,
   "message": "Checkout reviewed successfully",
   "data": {
      "cartId": "GUID",
      "market": {
         "id": "GUID",
         "name": "Fresh Market",
         "logoUrl": "https://..."
      },
      "deliveryAddress": "Nasr City, Abbas El Akkad, Building 10",
      "items": [
         {
            "cartItemId": "GUID",
            "productId": "GUID",
            "name": "Tomatoes",
            "quantity": 2,
            "unitPrice": 35,
            "total": 70,
            "available": true,
            "allowSubstitution": true
         }
      ],
      "summary": {
         "subtotal": 70,
         "discount": 0,
         "deliveryFee": 20,
         "serviceFee": 5,
         "total": 95,
         "currency": "EGP"
      },
      "canPlaceOrder": true
   }
}
```

Response `data` shape:
```json
{
   "cartId": "guid",
   "market": {
      "id": "guid",
      "name": "string",
      "logoUrl": "string | null"
   },
   "deliveryAddress": "string",
   "items": [
      {
         "cartItemId": "guid",
         "productId": "guid",
         "name": "string",
         "quantity": 0,
         "unitPrice": 0,
         "total": 0,
         "available": true,
         "allowSubstitution": true
      }
   ],
   "summary": {
      "subtotal": 0,
      "discount": 0,
      "deliveryFee": 0,
      "serviceFee": 0,
      "total": 0,
      "currency": "EGP"
   },
   "canPlaceOrder": true
}
```

---

## 7. Orders APIs

Controller:
- `/api/orders`

### 7.1 Place order

- Method: `POST`
- URL: `/api/orders`
- Auth: customer token required

Request body:
```json
{
   "cartId": "GUID",
   "deliveryAddress": "Nasr City, Abbas El Akkad, Building 10",
   "paymentMethod": "Cash",
   "couponCode": null,
   "deliveryInstructions": "Call me when you arrive"
}
```

Request shape:
```json
{
   "cartId": "guid",
   "deliveryAddress": "string | null",
   "paymentMethod": "string",
   "couponCode": "string | null",
   "deliveryInstructions": "string | null"
}
```

Success response:
```json
{
   "success": true,
   "message": "Order placed successfully",
   "data": {
      "id": "GUID",
      "orderNumber": "YG-1001",
      "status": "Pending",
      "market": {
         "id": "GUID",
         "name": "Fresh Market",
         "phone": "01000000001"
      },
      "deliveryAddress": "Nasr City, Abbas El Akkad, Building 10",
      "items": [
         {
            "id": "GUID",
            "productId": "GUID",
            "name": "Tomatoes",
            "imageUrl": "https://...",
            "quantity": 2,
            "unitPrice": 35,
            "totalPrice": 70
         }
      ],
      "payment": {
         "method": "Cash",
         "status": "Pending"
      },
      "summary": {
         "subtotal": 70,
         "discount": 0,
         "deliveryFee": 20,
         "serviceFee": 5,
         "total": 95,
         "currency": "EGP"
      },
      "deliveryInstructions": "Call me when you arrive",
      "createdAt": "2026-09-13T12:00:00Z"
   }
}
```

Response `data` shape:
```json
{
   "id": "guid",
   "orderNumber": "string",
   "status": "string",
   "market": {
      "id": "guid",
      "name": "string",
      "phone": "string | null"
   },
   "deliveryAddress": "string",
   "items": [
      {
         "id": "guid",
         "productId": "guid",
         "name": "string",
         "imageUrl": "string | null",
         "quantity": 0,
         "unitPrice": 0,
         "totalPrice": 0
      }
   ],
   "payment": {
      "method": "string",
      "status": "string"
   },
   "summary": {
      "subtotal": 0,
      "discount": 0,
      "deliveryFee": 0,
      "serviceFee": 0,
      "total": 0,
      "currency": "EGP"
   },
   "deliveryInstructions": "string | null",
   "createdAt": "datetime"
}
```

### 7.2 Get my orders

- Method: `GET`
- URL: `/api/orders?page=1&pageSize=10`
- Auth: customer token required

Request body:
- none

Success response:
```json
{
   "success": true,
   "message": "Orders retrieved successfully",
   "data": {
      "data": [
         {
            "id": "GUID",
            "orderNumber": "YG-1001",
            "marketName": "Fresh Market",
            "status": "Pending",
            "total": 95,
            "createdAt": "2026-09-13T12:00:00Z"
         }
      ],
      "pagination": {
         "page": 1,
         "pageSize": 10,
         "totalCount": 1,
         "totalPages": 1
      }
   }
}
```

Response `data` shape:
```json
{
   "data": [
      {
         "id": "guid",
         "orderNumber": "string",
         "marketName": "string",
         "status": "string",
         "total": 0,
         "createdAt": "datetime"
      }
   ],
   "pagination": {
      "page": 1,
      "pageSize": 10,
      "totalCount": 0,
      "totalPages": 0
   }
}
```

### 7.3 Get order details

- Method: `GET`
- URL: `/api/orders/{orderId}`
- Auth: customer token required

Request body:
- none

Success response:
- same wrapped `OrderResponseDto` as place order

### 7.4 Cancel order

- Method: `POST`
- URL: `/api/orders/{orderId}/cancel`
- Auth: customer token required

Request body:
- none

Success response:
- same wrapped `OrderResponseDto` as place order if service returns updated order

Safe frontend assumption:
```json
{
   "success": true,
   "message": "Order cancelled successfully",
   "data": {
      "id": "GUID",
      "orderNumber": "YG-1001",
      "status": "Cancelled"
   }
}
```

### 7.5 Update order status

- Method: `PATCH`
- URL: `/api/orders/{orderId}/status`
- Auth: vendor token required

Request body:
```json
{
   "status": "Preparing"
}
```

Request shape:
```json
{
   "status": "string"
}
```

Success response:
- same wrapped `OrderResponseDto` or updated order payload depending on service implementation

### 7.6 Update payment status

- Method: `PATCH`
- URL: `/api/orders/{orderId}/payment-status`
- Auth: vendor token required

Request body:
```json
{
   "paymentStatus": "Paid"
}
```

Request shape:
```json
{
   "paymentStatus": "string"
}
```

Success response:
- same wrapped `OrderResponseDto` or updated order payload depending on service implementation

---

## 8. Quick Endpoint Matrix

### AuthenticationController
- `GET /api/authentication/customers` -> `Result<IEnumerable<CustomerDto>>`
- `GET /api/authentication/vendors` -> `Result<IEnumerable<VendorDto>>`
- `POST /api/authentication/login` -> request `LoginDto`, response `Result<AuthResponseDto>`
- `POST /api/authentication/register/customer` -> request `RegisterCustomerDto`, response `Result<AuthResponseDto>`
- `POST /api/authentication/register/vendor` -> request `RegisterVendorDto`, response `Result<AuthResponseDto>`

### MarketsController
- `GET /api/markets` -> `Result<IEnumerable<MarketDto>>`
- `GET /api/markets/{marketId}` -> `Result<MarketDetailsDto>`
- `GET /api/markets/{marketId}/products` -> `Result<PagedResultDto<ProductDto>>`

### ProductsController
- `GET /api/products` -> `Result<IEnumerable<ProductDto>>`
- `GET /api/products/{productId}` -> `Result<ProductDto>`
- `GET /api/products/mine` -> `Result<IEnumerable<ProductDto>>`
- `POST /api/products` -> request `CreateProductDto`, response `Result<ProductDto>`
- `PUT /api/products/{productId}` -> request `UpdateProductDto`, response `Result<ProductDto>`
- `DELETE /api/products/{productId}` -> wrapped success/failure response

### CategoriesController
- `GET /api/categories/mine` -> `Result<IEnumerable<CategoryDto>>`
- `GET /api/categories/{categoryId}` -> `Result<CategoryDto>`
- `POST /api/categories` -> request `CreateCategoryDto`, response `Result<CategoryDto>`
- `PUT /api/categories/{categoryId}` -> request `UpdateCategoryDto`, response `Result<CategoryDto>`
- `DELETE /api/categories/{categoryId}` -> wrapped success/failure response

### CartController
- `GET /api/cart` -> `Result<CartResponseDto>`
- `POST /api/cart/items` -> request `AddCartItemDto`, response `Result<CartResponseDto>` or custom `409`
- `PATCH /api/cart/items/{itemId}` -> request `UpdateCartItemDto`, response `Result<CartResponseDto>`
- `DELETE /api/cart/items/{itemId}` -> wrapped success/failure response
- `DELETE /api/cart` -> wrapped success/failure response
- `POST /api/cart/checkout` -> request `CheckoutCartDto`, response `Result<CheckoutResponseDto>`

### OrdersController
- `POST /api/orders` -> request `PlaceOrderDto`, response `Result<OrderResponseDto>`
- `GET /api/orders` -> `Result<PagedResultDto<OrderListItemDto>>`
- `GET /api/orders/{orderId}` -> `Result<OrderResponseDto>`
- `POST /api/orders/{orderId}/cancel` -> wrapped updated order or success response
- `PATCH /api/orders/{orderId}/status` -> request `UpdateOrderStatusDto`, wrapped updated order or success response
- `PATCH /api/orders/{orderId}/payment-status` -> request `UpdatePaymentStatusDto`, wrapped updated order or success response