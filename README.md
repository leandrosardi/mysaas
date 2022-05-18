# my-free-membership-site

**my-free-membership-site** is an open-source, extensible and scalable platform for selling memberships and subscriptions online.

![dashboard example](./thumbnails/dashboard.png)

Use **my-free-membership-site** to develop any kind of:
- softwares as a service;
- educational site;
- e-commerce store;
- forum;
- social network;
- etc.

Some features of **my-free-membership-site** include:

1. **user security**: 
	- user signup,
	- email confirmation, 
	- user login, 
	- password reset, 
	- timezone configuration and 
	- user preferences;

2. **invoicing** and payments processing;

3. **email notifications** with easy setup of automation rules;

4. **affiliates tracking** for managing resellers and pay commission;

5. **domain aliasing** for licencing your site to other companies;

6. **abuse preventing** by tracking user's network and browser fingertings;

7. **shadow profiling** [[1](https://en.wikipedia.org/wiki/Shadow_profile)] for sales optimizations and client retention;

8. **horizontal scalability** of both: database and webservers;

9. **access points publishing** to connect your site with any other products;

10. **background processesing** for offline tasks like reports generation, payments processing, email notifications, web scraping, other tasks planning or dispatching, etc.;

11. **extensiblilty**, writing your own modules or installing the modules of thirth parties.

## Software Requirements

**my-free-membership-site** has been tested on:

- Ubuntu 18.04
- PostgreSQL 14
- Ruby 2.2.4

If you have skills in any of: design, Ruby, PostgreSQL or Bootstrap and would like to tackle something on this roadmap, we'd be grateful!

## 1. Getting Started

**Step 1:** Clone the project:

```bash
cd ~
git clone https://github.com/leandrosardi/my-free-membership-site
```

**Step 2:** Run the ruby script for installing required gems and database.

```bash
cd ~/my-free-membership-site
ruby ./install.rb db=kepler ip=127.0.0.1 port=5432 user=postgres password=<write your password here>
```

**Step 3:** Running the Web Server

```bash
cd ~/my-free-membership-site
ruby ./run.rb db=kepler 
```

Finally, open a new browser, go to [http://127.0.0.1:80/login](http://127.0.0.1:80/login) and access with default user `demo` and password `demo`.

![login screen](./thumbnails/login.png)

## 2. Installing Modules

**my-free-membership-site** is extensible. That means, you can install 3th parties modules to add features like payments processing; or any other module regarding the kind of product that you want to develop like e-commerce, online stores, software-as-a-service, education, social networks, etc.

If the module you need doesn't exists, you can create your own modules too.

Installing a module is as simple as running a Ruby script:

```bash
cd ~/my-free-membership-site
ruby ./add.rb name=<module name>
```

## 2.1. Installing [Processing Threads](https://github.com/leandrosardi/pampa) Module

The [Processing Threads](https://github.com/leandrosardi/pampa) is not a kind of commercial product, but a software for managing back-end processing of offline tasks easily.

[Processing Threads](https://github.com/leandrosardi/pampa) is a Ruby library for distributing computing providing the following features:

- cluster-management with dynamic reconfiguration (joining and leaving nodes);
- distribution of the computation jobs to the (active) nodes;
- error handling, job-retry and fault tolerance;
- fast (non-direct) communication to ensure realtime capabilities.

For technical details, refer to [Processing Threads on GitHub](https://github.com/leandrosardi/pampa).

To install [Processing Threads](https://github.com/leandrosardi/pampa), run this Ruby script:

```bash
cd ~/my-free-membership-site
ruby ./add.rb name=threads
```

## 2.2. Installing [Invoicing & Payments Processing](https://github.com/leandrosardi/invoicing_payments_processing) Module

[Invoicing & Payments Processing](https://github.com/leandrosardi/invoicing_payments_processing) (a.k.a. **I2P**) is a library for 

1. configuring products, prices, offers, and subscriptions; 
2. show invoices and PayPal subscriptions; 
3. processing PayPal notifications; 
and
4. track the finanical history of your customers. 

For technical details, refer to [Invoicing & Payments Processing](https://github.com/leandrosardi/invoicing_payments_processing).

To install [Processing Threads](https://github.com/leandrosardi/pampa), run this Ruby script:

```bash
cd ~/my-free-membership-site
ruby ./add.rb name=i2p
```

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


