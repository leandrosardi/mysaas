# my-membership-site

My-Membership-Site is an open-source, extensible and scalable platform for selling memberships and subscriptions online.

![login screen](./thumbnails/login.png)

Software Requirements:
- Ruby 2.2.4
- PostgreSQL 14

If you have skills in any of: design, Ruby, PostgreSQL or Bootstrap and would like to tackle something on this roadmap, we'd be grateful!

## 1. Getting Started

**Step 1:** Clone the project:

```bash
cd ~
git clone https://github.com/leandrosardi/my-membership-site
```

**Step 2:** Run the ruby script for installing required gems and database.

```bash
cd ~/my-membership-site
ruby install.rb db=kepler ip=127.0.0.1 port=5432 user=postgres password=<write your password here>
```

**Step 3:** Running Web Servers

```bash
cd ~/my-membership-site
ruby run.rb db=kepler 
```

Finally, open a new browser, go to `http://127.0.0.1:80/login` and access with default user `demo` and password `demo`.

## 2. Installing Modules

## 3. User Roles

## 4. Installing SSL Certificates

## 5. Scaling Out Database

### 5.1. Scaling Out with Native Databases Sharding

### 5.2. Scaling Out with [CockroachDB](https://www.cockroachlabs.com/docs/cockroachcloud/quickstart.html)

## 6. Scaling Out WebServer

### 6.1. Scaling Out with Native NGINX extension

### 6.2. Scaling Out with Cloud Hosting Load Balancers

## 7. User Preferences

## 8. Email Notifications

### 8.1. Setup Notification

### 8.2. Delivering Email Notificaiton

### 8.3. Tracking Opens

### 8.4. Tracking Clicks

## 9. Client Storage

## 10. Client TimeZones and Time Offsets

## 11. Removing Client Data

## 12. Client Email & Domains Aliasing

### 12.1. Email Aliasing

### 12.2. Domain Aliasing

### 12.3. Other Clients Ownership

## 13. Client API-Key

## 14. DB Stored Parameters

## 15. Writing Modules


