![logo](./logo.png)

# MySaaS - Open Source SaaS Platform - Extensible and Scalable.  

**IMPORTANT:**
This project is under construction.
The first version will be released on 1-Jun-2022.
Check out [our roadmap here](https://github.com/users/leandrosardi/projects/5).

**MySaaS** is an open-source, extensible and scalable platform for develop your own SaaS, e-Commerce, Education Platform, Social Network, Forum or any kind of memberships based product.

![dashboard example](./docu/thumbnails/dashboard.png)

Use **MySaaS** to develop any kind of:
- softwares as a service;
- educational site;
- e-commerce store;
- forum;
- social network;
- etc.

If you have skills in any of: design, Ruby, PostgreSQL or Bootstrap and would like to tackle something on this roadmap, we'd be grateful!

## Getting Started

**Step 1:** Install the Environment

**MySaaS** has been tested with Ubuntu 20.04 and Ruby 3.1.2.
Other configurations may not be stable.

If you are trying to install **MySaaS** on other configuration, and our automation scripts are not working; please refer to this [tutorial for manual installation](https://github.com/leandrosardi/mysaas/issues/16#issuecomment-1137154114). 

**Step 1:** Clone the project.

Get the source code from GitHub.

```bash
mkdir ~/code
cd ~/code
git clone https://github.com/leandrosardi/mysaas
```

If you get a permissions error, prefix the command with sudo.

**Step 2:** Add `~/code/mysaas` to the require path.

**MySaaS** provides many CLI tools for automation of some repetitive tasks, like deployment or packages building.

```bash
export RUBYLIB=~/code/mysaas
```

**Step 3:** Install [blackstack-deployer](https://github.com/leandrosardi/blackstack-deployer) and [simple_command_line_parser](https://github.com/leandrosardi/simple_command_line_parser) gems.

Our [blackstack-deployer](https://github.com/leandrosardi/blackstack-deployer) will help you to install the database engine, create the database schema, seed the database with initial data, install all required gems and run the webserver. All of them from one single line of code!

```bash
gem install blackstack-deployer
```

Our [simple_command_line_parser](https://github.com/leandrosardi/simple_command_line_parser) is just a library for define command line arguments.

```bash
gem install simple_command_line_parser
```

**Step 4:** Install the Envionment.

As said above, our [blackstack-deployer](https://github.com/leandrosardi/blackstack-deployer) will help you to install the database engine, create the database schema, seed the database with initial data, install all required gems and run the webserver. All of them from one single line of code!

The command below performs many installation tasks:

```bash
cd ~/code/mysaas
ruby ./install.rb ssh_hostname=127.0.0.1 ssh_port=22 ssh_username=ubuntu ssh_private_key_file=./plank.pem local=yes laninterface=eth0
```

The command may take many hours to install the seed records on the database.

Once the command have done, open a new browser, go to [http://127.0.0.1:80/login](http://127.0.0.1:80/login) and access with default user `su` and password `su1234`.


Such installation tasks are:
1. install CockrouchDB 22.1 in your server; 
2. install required Ruby gems;
3. creating the database schema; 
4. install seed records into the database; and
5. run the webserver.


**Some considerations:**

- If you have not a private key to connect your computer via SSH, use the parameter `ssh_password` instead `ssh_private_key_file`.

- Be sure that your `ssh_user` is in the list of sudoers.

- Be sure your firewall is not blocking ports 80 (the SaaS website), 8080 (the CockroachDB dashboard) and 26257 (the CockroachDB database).

- Use `ifconfig` to get the name of your LAN interface, and assign it to the `laninterface` parameter.

- Use `local=yes` when you are installing your local environment for development. Remove that parameter if you are running the command for a remote computer.

- After running the installer, you will probably have not grants for installing or uninstalling gems. You can get back such grants running `cd /usr/local/rvm/gems/ruby-3.1.2;sudo chown -R $USER:$USER .`.


**Additional Readings:**

1. Read documentation about our [Simple Command Line Parser](https://github.com/leandrosardi/simple_command_line_parser) in order to know how does the parsing of command line parameters work.

2. The `install.rb` command has many paremeters. Find the definition of them [here](https://github.com/leandrosardi/mysaas/blob/0.0.1/install.rb#L11).

3. Read documentation about our [Simple Cloud Logging](https://github.com/leandrosardi/simple_cloud_logging) in order to know more about how we write logs on all our processes and CLI tools.

4. Read documentation about our [BlackStack Deployer](https://github.com/leandrosardi/blackstack-deployer) in order to know more about how do we automate the deploying of software to a large fleet of servers.


![login screen](./docu/thumbnails/login.png)

## Features & Documentation

Some features of **MySaaS** include:

1. [account management](./docu/1.accounts-management.md);

2. [invoicing and payments processing](./docu/2.invoicing-and-payments-processing.md);

3. [email notifications](./docu/3.email-notifications.md) with easy setup of automation rules;

4. [affiliates tracking](./docu/4.affiliates-tracking.md) for managing resellers and pay commission;

5. [domain aliasing](./docu/5.domain-aliasing.md) for licencing your site to other companies;

6. [abuse preventing](./docu/6.abuse-preventing.md) by tracking user's network and browser fingertings;

7. [shadow profiling](./docu/7.shadow-profiling.md) [[1](https://en.wikipedia.org/wiki/Shadow_profile)] for sales optimizations and client retention;

8. [SSL certificates](./docu/8.ssl-certificates.md) support;

9. [horizontal scalability](./docu/9.horizontal-scalability.md) of both: database and webservers;

10. [access points and RPC](./docu/10.access-points-and-rpc.md) to connect your site with any other products;

11. [background processesing](./docu/11.background-processesing.md) for offline tasks like reports generation, payments processing, email notifications, web scraping, other tasks planning or dispatching, etc.;

12. [extensiblilty](./docu/12.extensiblilty.md), writing your own modules or installing the modules of thirth parties;

13. automated deploying;

14. stored parameters;

15. appendix 1: writing modules;

16. appendix 2: managing transcactional and historical data;

17. appendix 3: archiving inactive account.

## Dependencies

The logo has been taken from [here](https://www.shareicon.net/supermarket-shopping-store-commerce-and-shopping-online-store-shopping-cart-commerce-802984).