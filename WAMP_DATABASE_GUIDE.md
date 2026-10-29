# 🐬 WAMP MySQL & Database Setup Guide for SmartTrip

## 📌 Executive Summary

Your **SmartTrip** application now supports **both WampServer MySQL and MongoDB**:

1. **WAMP MySQL (`smart_trip_db`)**:
   - Created and fully populated in your local WampServer MySQL on port `3306`.
   - Access anytime via **phpMyAdmin**: [http://localhost/phpmyadmin/](http://localhost/phpmyadmin/)
   - Standalone export file: [`smart_trip_wamp.sql`](file:///d:/BSC%20SE/smart-trip-app/smart_trip_wamp.sql) (33.8 KB) in the project root.
2. **Node.js + React Web App**:
   - Backend automatically connects to both databases.
   - All 17 collections/tables are populated with realistic Sri Lanka travel destinations, itineraries, inventory, users, and bookings.

---

## 🗄️ 1. WAMP MySQL Database Details

- **Database Name**: `smart_trip_db`
- **Host**: `127.0.0.1` (localhost)
- **Port**: `3306` (WampServer default)
- **Username**: `root`
- **Password**: *(empty by default in WAMP)*
- **Charset**: `utf8mb4` / `utf8mb4_unicode_ci`

### Installed Tables (17 Tables)

| Category | Tables |
| :--- | :--- |
| **Core Entities** | `users`, `vendors`, `inventory_items`, `trips`, `bookings`, `booking_items` |
| **User Activity** | `saved_trips`, `reviews`, `notifications` |
| **Platform Config** | `config_provinces`, `config_cities`, `config_services`, `config_destinations`, `config_preferences`, `config_banks`, `config_workflows`, `config_itinerary_items` |

---

## 🔑 2. Seeded Test Credentials

Use these accounts to test the application or verify in MySQL/MongoDB:

| Role | Email | Password | Details |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin@smarttrip.lk` | `Admin@123` | Full access to Admin Dashboard |
| **Traveler (User 1)** | `thisara@example.com` | `User@123` | Has 2 confirmed bookings (Galle & Kandy) |
| **Traveler (User 2)** | `nimasha@example.com` | `User@123` | Has bookings & reviews |
| **Vendor 1** | `roshan.vendor@example.com` | `Vendor@123` | Ceylon Journeys Pvt Ltd (Tour Operator) |
| **Vendor 2** | `amaya.vendor@example.com` | `Vendor@123` | Amaya Coastal Tours (Travel Agency) |
| **Vendor 3** | `hotels.earls@example.com` | `Vendor@123` | Earl's Regency Hotel (Kandy) |

---

## 🚀 3. How to View in WAMP phpMyAdmin

1. Ensure **WampServer** is running (green icon in taskbar).
2. Open your browser and navigate to: **[http://localhost/phpmyadmin/](http://localhost/phpmyadmin/)**
3. Log in with:
   - **Username**: `root`
   - **Password**: *(leave blank)*
4. Select **`smart_trip_db`** from the left navigation panel.
5. You can view all tables, structure, ER relations, and run SQL queries.

---

## 🔄 4. How to Re-import or Reset the MySQL Database

If you ever need to reset or re-import the MySQL database in WAMP:

### Option A: Via Command Prompt / PowerShell
```powershell
Get-Content "D:\BSC SE\smart-trip-app\smart_trip_wamp.sql" | & "C:\wamp64\bin\mysql\mysql8.4.7\bin\mysql.exe" -u root
```

### Option B: Via phpMyAdmin UI
1. Go to **phpMyAdmin** → click **Import**.
2. Choose file: `D:\BSC SE\smart-trip-app\smart_trip_wamp.sql`.
3. Click **Import** at the bottom.

---

## 🩺 5. Live Verification Endpoints

- **Health Check**: [http://localhost:5002/health](http://localhost:5002/health)
- **Database Status**: [http://localhost:5002/api/database/status](http://localhost:5002/api/database/status)
- **Frontend App**: [http://localhost:5180](http://localhost:5180)
