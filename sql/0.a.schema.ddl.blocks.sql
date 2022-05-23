/*
 * CREATE DATABASE no puede ser ejecutado dentro de un bloque de transaccion
 *
CREATE DATABASE %database_name%
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Argentina.1252'
    LC_CTYPE = 'Spanish_Argentina.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE kepler
    IS 'This is the master database where all users are stored.';
*/

/*
-- creating the blackstack_prod user, who will access the database from production servers.
CREATE ROLE blackstack_prod WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD '%blackstack_prod_password%';
COMMENT ON ROLE blackstack_prod IS 'These are the users who access the database from production.';

-- creating the blackstack_devs user, who will access the database from with reading-grants only.
CREATE ROLE blackstack_devs WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD '%blackstack_devs_password%';
COMMENT ON ROLE blackstack_prod IS 'These are the users who access the database from with reading-only grants.';

-- TODO: grant the user blackstack_prod

-- TODO: grant the user blackstack_prod
*/

-- create extension to handle guids
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- possible countries assigned to a user.
CREATE TABLE IF NOT EXISTS country(
	id uuid NOT NULL PRIMARY KEY,
	code char(500) NOT NULL,
	name char(500) NOT NULL
);

-- timezome assigned to an account.
-- use this with timeoffet to get the current time in the timezone of the user, schedule notifications, etc.
CREATE TABLE IF NOT EXISTS timezone(
	id uuid NOT NULL PRIMARY KEY,
	"offset" float NOT NULL,
	large_description char(500) NULL,
	short_description char(500) NULL
);

-- each signup creates a new account.
-- each account has one or more users.
CREATE TABLE IF NOT EXISTS account (
	id uuid NOT NULL PRIMARY KEY,
	id_account_owner uuid NOT NULL REFERENCES account(id), -- this field is for white-labeling purposes. You need to know who is the owner of a new account.
	name char(500) NOT NULL,
	create_time timestamp NOT NULL,
	delete_time timestamp NULL,
	id_timezone uuid NOT NULL,
	storage_total_kb bigint NOT NULL, -- max allowed KB in the storage for this client
	domain_for_ssm char(500) NULL,
	from_email_for_ssm char(500) NULL,
	from_name_for_ssm char(500) NULL,
	domain_for_ssm_verified bool NULL,
	id_user_to_contact uuid NULL, -- this is the user owner of the account
	api_key char(500) NULL
);

-- each user can login to his account.
CREATE TABLE IF NOT EXISTS "user" (
	id uuid NOT NULL PRIMARY KEY,
	id_account uuid NOT NULL REFERENCES account(id),
	create_time timestamp NOT NULL,
	delete_time timestamp NULL,
	email char(500) UNIQUE NOT NULL,
	password char(5000) NOT NULL,
	name char(500) NOT NULL,
	phone char(500) NULL,
	verified bool NULL
);

-- each account has an owner.
ALTER TABLE account DROP CONSTRAINT IF EXISTS FK__account__id_user_to_contact;
ALTER TABLE account ADD CONSTRAINT FK__account__id_user_to_contact FOREIGN KEY (id_user_to_contact) REFERENCES "user" (id);

-- store user preferences like: table filters, default values on some forms, communiction, etc.
CREATE TABLE IF NOT EXISTS preference (
	id uuid NOT NULL PRIMARY KEY,
	id_user uuid NOT NULL REFERENCES "user" (id),
	create_time timestamp NOT NULL,
	name char(500)  NOT NULL,
	type int NOT NULL, -- which type of value is stored here: string (0), int (1), float(2), bool (3)
	value_string char(500) NULL,
	value_int int NULL,
	value_float float NULL,
	value_bool bool NULL
);

-- email notifications delivered to users
CREATE TABLE IF NOT EXISTS notification (
	id uuid NOT NULL PRIMARY KEY,
	create_time timestamp NOT NULL,
	delivery_time timestamp NULL,
	type int NOT NULL,
	id_user uuid NOT NULL REFERENCES "user" (id), 
	name_to char(500) NOT NULL,
	email_to char(500) NOT NULL,
	name_from char(500) NOT NULL,
	email_from char(500) NOT NULL,
	subject char(500) NOT NULL,
	body text NOT NULL
);

-- this is a parmetric read-only table, to store the time offset regarding GTM-0 for different timezones.
CREATE TABLE IF NOT EXISTS timeoffset(
	id uuid NOT NULL PRIMARY KEY,
	region char(500) NOT NULL,
	utc numeric(2, 0) NOT NULL,
	dst numeric(2, 0) NULL
);

-- well known zip codes to assign to a user.
CREATE TABLE IF NOT EXISTS zipcode (
	value char(500) NOT NULL PRIMARY KEY
);

-- possible roles for a user
CREATE TABLE IF NOT EXISTS "role" (
	id uuid NOT NULL PRIMARY KEY,
	name char(500) NOT NULL
);

-- roles assigned to each user
CREATE TABLE IF NOT EXISTS user_role (
	id uuid NOT NULL PRIMARY KEY,
	create_time timestamp NOT NULL,
	id_creator uuid NOT NULL REFERENCES "user" (id),
	id_user uuid NOT NULL REFERENCES "user" (id),
	id_role uuid NOT NULL REFERENCES "role" (id),
);

-- register the login of each user
CREATE TABLE IF NOT EXISTS login (
	id uuid NOT NULL PRIMARY KEY,
	id_user uuid NOT NULL REFERENCES "user" (id),
	create_time timestamp NOT NULL
);

-- auxiliar table to store all days
CREATE TABLE IF NOT EXISTS daily (
	"date" date NOT NULL PRIMARY KEY
);

-- auxiliar table to store all day-hours
CREATE TABLE IF NOT EXISTS hourly (
	hour numeric(18, 0) NOT NULL PRIMARY KEY
);

-- auxiliar table to store all hour-minutes
CREATE TABLE IF NOT EXISTS minutely (
	minute numeric(18, 0) NOT NULL PRIMARY KEY
);
