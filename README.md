![logo](./logo.png)

# My SaaS

**IMPORTANT:**
This project is under construction.
The first version will be released on 1-Jun-2022.
Check out [our roadmap here](https://github.com/users/leandrosardi/projects/5).

**My SaaS** is an open-source, extensible and scalable platform for develop your own SaaS, e-Commerce, Education Platform, Social Network, Forum or any kind of memberships based product.

![dashboard example](./thumbnails/dashboard.png)

Use **My SaaS** to develop any kind of:
- softwares as a service;
- educational site;
- e-commerce store;
- forum;
- social network;
- etc.

If you have skills in any of: design, Ruby, PostgreSQL or Bootstrap and would like to tackle something on this roadmap, we'd be grateful!

## Getting Started

**Step 1:** Install the Environment

**free-memembership-sites** has been tested with Ubuntu 20.04 and Ruby 3.1.2.
Other configurations may not be stable.

If you are trying to install **My SaaS** on other configuration, and our automation scripts are not working; please refer to this [tutorial for manual installation](https://github.com/leandrosardi/My SaaS/issues/16#issuecomment-1137154114). 

**Step 1:** Clone the project.

Get the source code from GitHub.

```bash
mkdir ~/code
cd ~/code
git clone https://github.com/leandrosardi/My SaaS
```

If you get a permissions error, prefix the command with sudo.

**Step 2:** Install [blackstack-deployer](https://github.com/leandrosardi/blackstack-deployer) and [simple_command_line_parser](https://github.com/leandrosardi/simple_command_line_parser) gems.

Our [blackstack-deployer](https://github.com/leandrosardi/blackstack-deployer) will help you to install the database engine, create the database schema, seed the database with initial data, install all required gems and run the webserver. All of them from one single line of code!

```bash
gem install blackstack-deployer
```

Our [simple_command_line_parser](https://github.com/leandrosardi/simple_command_line_parser) is just a library for define command line arguments.

```bash
gem install simple_command_line_parser
```

**Step 3:** Install the Envionment.

As said above, our [blackstack-deployer](https://github.com/leandrosardi/blackstack-deployer) will help you to install the database engine, create the database schema, seed the database with initial data, install all required gems and run the webserver. All of them from one single line of code!

The command below performs many installation tasks:

```bash
cd ~/code/My SaaS
ruby ./install.rb ssh_hostname=127.0.0.1 ssh_port=22 ssh_username=ubuntu ssh_private_key_file=./plank.pem
```

Such installation tasks are:
1. install CockrouchDB 22.1 in your server; 
2. install required Ruby gems;
3. creating the database schema; 
4. install seed records into the database; and
5. run the webserver.

Finally, open a new browser, go to [http://127.0.0.1:80/login](http://127.0.0.1:80/login) and access with default user `su` and password `su`.

The `install.rb` command has many paremeters, as listed below:

_(pending)_

![login screen](./thumbnails/login.png)

## Features & Documentation

Some features of **My SaaS** include:

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

12. [extensiblilty](./docu/12.extensiblilty), writing your own modules or installing the modules of thirth parties;

13. automated deploying;

14. stored parameters;

15. appendix 1: writing modules;

16. appendix 2: managing transcactional and historical data;

17. appendix 3: archiving inactive account.

## Dependencies

The logo has been taken from [here](https://www.shareicon.net/supermarket-shopping-store-commerce-and-shopping-online-store-shopping-cart-commerce-802984).