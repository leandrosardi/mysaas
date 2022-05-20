# free-membership-sites

**IMPORTANT:**
This project is under construction.
The first version will be released on 1-Jun-2022.
Check out [our roadmap here](https://github.com/users/leandrosardi/projects/5).

**my-free-membership-site** is an open-source, extensible and scalable platform for selling memberships and subscriptions online.

![dashboard example](./thumbnails/dashboard.png)

Use **my-free-membership-site** to develop any kind of:
- softwares as a service;
- educational site;
- e-commerce store;
- forum;
- social network;
- etc.

## Software Requirements

**my-free-membership-site** has been tested on:

- Ubuntu 18.04;
- PostgreSQL 14; and
- Ruby 2.2.4

If you have skills in any of: design, Ruby, PostgreSQL or Bootstrap and would like to tackle something on this roadmap, we'd be grateful!

## Features

Some features of **my-free-membership-site** include:

1. [account management](./docu/1.accounts-management.md);

2. [invoicing and payments processing](./docu/2.invoicing-and-payments-processing);

3. [email notifications](./docu/3.email-notifications) with easy setup of automation rules;

4. [affiliates tracking](./docu/4.affiliates-tracking) for managing resellers and pay commission;

5. [domain aliasing](./docu/5.domain-aliasing) for licencing your site to other companies;

6. [abuse preventing](./docu/6.abuse-preventing) by tracking user's network and browser fingertings;

7. [shadow profiling](./docu/7.shadow-profiling) [[1](https://en.wikipedia.org/wiki/Shadow_profile)] for sales optimizations and client retention;

8. [SSL certificates](./docu/8.ssl-certificates) support;

9. [horizontal scalability](./docu/9.horizontal-scalability) of both: database and webservers;

10. [access points publishing](./docu/10.access-points-publishing) to connect your site with any other products;

11. [background processesing](./docu/11.background-processesing) for offline tasks like reports generation, payments processing, email notifications, web scraping, other tasks planning or dispatching, etc.;

12. [extensiblilty](./docu/12.extensiblilty), writing your own modules or installing the modules of thirth parties.

13. DB Stored Parameters

14. Writing Modules

15. Removing Client Data

## Getting Started

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






