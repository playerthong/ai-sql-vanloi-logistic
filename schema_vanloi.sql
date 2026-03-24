-- public.erp_business_cost_config definition

-- Drop table

-- DROP TABLE public.erp_business_cost_config;

CREATE TABLE public.erp_business_cost_config (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	"name" varchar(255) NOT NULL,
	code varchar(50) NOT NULL,
	"type" varchar(20) NOT NULL, -- FIXED: Chi phí cố định, VARIABLE: Chi phí biến đổi
	account_number varchar(50) NULL,
	description text NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted timestamp NULL,
	is_deleted bool DEFAULT false NOT NULL,
	department_external_id uuid NULL,
	create_uid uuid NULL,
	CONSTRAINT erp_business_cost_config_code_key UNIQUE (code),
	CONSTRAINT erp_business_cost_config_pkey PRIMARY KEY (id),
	CONSTRAINT uq_business_cost_config_external_id UNIQUE (external_id)
);

-- Column comments

COMMENT ON COLUMN public.erp_business_cost_config."type" IS 'FIXED: Chi phí cố định, VARIABLE: Chi phí biến đổi';


-- public.erp_business_cost_config_department definition

-- Drop table

-- DROP TABLE public.erp_business_cost_config_department;

CREATE TABLE public.erp_business_cost_config_department (
	id serial4 NOT NULL,
	config_external_id uuid NOT NULL,
	department_external_id uuid NOT NULL,
	CONSTRAINT erp_business_cost_config_depa_config_external_id_department_key UNIQUE (config_external_id, department_external_id),
	CONSTRAINT erp_business_cost_config_department_pkey PRIMARY KEY (id)
);


-- public.erp_calculator definition

-- Drop table

-- DROP TABLE public.erp_calculator;

CREATE TABLE public.erp_calculator (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	project_external_id uuid NULL,
	vehicle_model_group_external_id uuid NULL,
	shift_name varchar(255) NULL,
	"name" varchar(255) NULL,
	active bool DEFAULT true NULL,
	"type" varchar(100) NULL,
	route_type varchar(100) NULL,
	default_km_monthly numeric(18, 4) DEFAULT 0 NULL,
	price_default_km_monthly numeric(18, 4) DEFAULT 0 NULL,
	price_over_default_per_km numeric(18, 4) DEFAULT 0 NULL,
	route_cost numeric(18, 4) DEFAULT 0 NULL,
	price_over_time numeric(18, 4) DEFAULT 0 NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	is_deleted bool DEFAULT false NOT NULL,
	code varchar(50) NOT NULL,
	CONSTRAINT erp_calculator_pkey PRIMARY KEY (id),
	CONSTRAINT uq_project_vehicle_model_group_shift UNIQUE (project_external_id, vehicle_model_group_external_id, shift_name)
);


-- public.erp_company_customer_allowance definition

-- Drop table

-- DROP TABLE public.erp_company_customer_allowance;

CREATE TABLE public.erp_company_customer_allowance (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_customer_revenue_external_id uuid NOT NULL,
	"name" varchar NOT NULL,
	description varchar NULL,
	"cost" numeric(18, 2) DEFAULT 0 NULL,
	is_multiple bool DEFAULT false NOT NULL,
	active bool NULL,
	create_uid uuid NULL,
	update_uid uuid NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	is_deleted bool DEFAULT false NOT NULL,
	template_allowance_id int4 NULL,
	unit varchar NULL,
	CONSTRAINT erp_company_customer_allowance_pkey PRIMARY KEY (id)
);


-- public.erp_company_customer_revenue definition

-- Drop table

-- DROP TABLE public.erp_company_customer_revenue;

CREATE TABLE public.erp_company_customer_revenue (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_customer_external_id uuid NOT NULL,
	code varchar NOT NULL,
	"name" varchar NOT NULL,
	gas_price numeric(18, 2) DEFAULT 0 NULL,
	start_time timestamp NULL,
	end_time timestamp NULL,
	active bool NULL,
	create_uid uuid NULL,
	update_uid uuid NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	is_deleted bool DEFAULT false NOT NULL,
	CONSTRAINT erp_company_customer_revenue_pkey PRIMARY KEY (id)
);


-- public.erp_company_customer_route_price definition

-- Drop table

-- DROP TABLE public.erp_company_customer_route_price;

CREATE TABLE public.erp_company_customer_route_price (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_customer_revenue_external_id uuid NOT NULL,
	route_external_id uuid NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	is_deleted bool DEFAULT false NOT NULL,
	CONSTRAINT erp_company_customer_route_price_pkey PRIMARY KEY (id),
	CONSTRAINT uq_route_company_customer UNIQUE (route_external_id, company_customer_revenue_external_id)
);


-- public.erp_company_logistic_allowance definition

-- Drop table

-- DROP TABLE public.erp_company_logistic_allowance;

CREATE TABLE public.erp_company_logistic_allowance (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_logistic_cost_external_id uuid NOT NULL,
	"name" varchar NOT NULL,
	description varchar NULL,
	"cost" numeric(18, 2) DEFAULT 0 NULL,
	is_multiple bool DEFAULT false NOT NULL,
	active bool NULL,
	create_uid uuid NULL,
	update_uid uuid NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	is_deleted bool DEFAULT false NOT NULL,
	template_allowance_id int4 NULL,
	unit varchar NULL,
	CONSTRAINT erp_company_logistic_allowance_pkey PRIMARY KEY (id),
	CONSTRAINT uq_company_logistic_cost_name UNIQUE (company_logistic_cost_external_id, name)
);


-- public.erp_company_logistic_cost definition

-- Drop table

-- DROP TABLE public.erp_company_logistic_cost;

CREATE TABLE public.erp_company_logistic_cost (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_logistic_external_id uuid NOT NULL,
	code varchar NOT NULL,
	"name" varchar NOT NULL,
	gas_price numeric(18, 2) DEFAULT 0 NULL,
	start_time timestamp NULL,
	end_time timestamp NULL,
	active bool NULL,
	create_uid uuid NULL,
	update_uid uuid NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	is_deleted bool DEFAULT false NOT NULL,
	CONSTRAINT erp_company_logistic_cost_pkey PRIMARY KEY (id)
);


-- public.erp_company_route_logistic_cost definition

-- Drop table

-- DROP TABLE public.erp_company_route_logistic_cost;

CREATE TABLE public.erp_company_route_logistic_cost (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_logistic_cost_external_id uuid NOT NULL,
	route_external_id uuid NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	is_deleted bool DEFAULT false NULL,
	CONSTRAINT erp_company_route_logistic_cost_pkey PRIMARY KEY (id),
	CONSTRAINT uq_route_company_logistic UNIQUE (route_external_id, company_logistic_cost_external_id)
);


-- public.erp_configuration definition

-- Drop table

-- DROP TABLE public.erp_configuration;

CREATE TABLE public.erp_configuration (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	sharemap_enable bool NOT NULL,
	min_version_android varchar NOT NULL,
	min_version_ios varchar NOT NULL,
	link_android varchar NULL,
	link_ios varchar NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	sharemap_api_key varchar(255) NULL,
	sharemap_access_api_key text NULL,
	link_web varchar(255) DEFAULT NULL::character varying NULL,
	CONSTRAINT erp_configuration_pkey PRIMARY KEY (id)
);


-- public.erp_driver definition

-- Drop table

-- DROP TABLE public.erp_driver;

CREATE TABLE public.erp_driver (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	"name" varchar NULL,
	phone varchar NOT NULL,
	driver_type varchar NULL,
	region varchar DEFAULT 'southern'::character varying NULL,
	active bool NULL,
	create_date timestamp NULL,
	write_date timestamp NULL,
	warning_name bool NULL,
	flag_3pl bool NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_external_id uuid NULL,
	country_code varchar(5) DEFAULT '84'::character varying NULL,
	user_external_id uuid NULL,
	first_name varchar(50) NULL,
	last_name varchar(150) NULL,
	create_uid uuid NULL,
	write_uid uuid NULL,
	external_code varchar NULL,
	zalo_id varchar NULL,
	CONSTRAINT erp_driver_pkey PRIMARY KEY (id),
	CONSTRAINT unique_phone UNIQUE (phone)
);
CREATE INDEX idx_driver_external ON public.erp_driver USING btree (external_id);


-- public.erp_driver_bank_account definition

-- Drop table

-- DROP TABLE public.erp_driver_bank_account;

CREATE TABLE public.erp_driver_bank_account (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	driver_external_id uuid NOT NULL,
	bank_name varchar(100) NOT NULL,
	account_number varchar(50) NOT NULL,
	account_name varchar(100) NOT NULL,
	brand_name varchar NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_driver_bank_account_pkey PRIMARY KEY (id)
);


-- public.erp_driver_card definition

-- Drop table

-- DROP TABLE public.erp_driver_card;

CREATE TABLE public.erp_driver_card (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	create_uid int4 NULL,
	write_uid int4 NULL,
	"name" varchar NULL,
	create_date timestamp NULL,
	write_date timestamp NULL,
	CONSTRAINT erp_driver_card_pkey PRIMARY KEY (id)
);


-- public.erp_driver_card_info definition

-- Drop table

-- DROP TABLE public.erp_driver_card_info;

CREATE TABLE public.erp_driver_card_info (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	driver_id int4 NULL,
	driver_card_id int4 NOT NULL,
	create_uid int4 NULL,
	write_uid int4 NULL,
	"name" varchar NULL,
	card_id varchar NULL,
	issue_date date NULL,
	create_date timestamp NULL,
	write_date timestamp NULL,
	CONSTRAINT erp_driver_card_info_pkey PRIMARY KEY (id)
);


-- public.erp_driver_transaction_wallet definition

-- Drop table

-- DROP TABLE public.erp_driver_transaction_wallet;

CREATE TABLE public.erp_driver_transaction_wallet (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	driver_wallet_external_id uuid NOT NULL,
	driver_bank_account_external_id uuid NOT NULL,
	amount numeric(18, 2) NOT NULL,
	prior_balance numeric(18, 2) NOT NULL,
	"method" varchar(50) NOT NULL,
	status varchar(50) NOT NULL,
	description varchar NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_driver_transaction_wallet_pkey PRIMARY KEY (id)
);


-- public.erp_driver_wallet definition

-- Drop table

-- DROP TABLE public.erp_driver_wallet;

CREATE TABLE public.erp_driver_wallet (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	driver_external_id uuid NOT NULL,
	balance numeric(18, 2) DEFAULT 0 NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_driver_wallet_pkey PRIMARY KEY (id)
);


-- public.erp_history_driver definition

-- Drop table

-- DROP TABLE public.erp_history_driver;

CREATE TABLE public.erp_history_driver (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	driver_external_id uuid NULL,
	"action" varchar NOT NULL,
	action_by uuid NOT NULL,
	action_at timestamp DEFAULT now() NULL,
	raw_data jsonb NULL,
	is_read bool DEFAULT false NULL,
	CONSTRAINT erp_history_driver_pkey PRIMARY KEY (id)
);


-- public.erp_history_route_customer_price definition

-- Drop table

-- DROP TABLE public.erp_history_route_customer_price;

CREATE TABLE public.erp_history_route_customer_price (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	route_customer_price_external_id uuid NULL,
	price numeric(18, 2) DEFAULT 0 NULL,
	"action" varchar NOT NULL,
	action_by uuid NOT NULL,
	"version" timestamp NULL,
	CONSTRAINT erp_history_route_customer_price_pkey PRIMARY KEY (id),
	CONSTRAINT uq_route_customer_price_version UNIQUE (route_customer_price_external_id, version)
);


-- public.erp_history_route_logistic_cost definition

-- Drop table

-- DROP TABLE public.erp_history_route_logistic_cost;

CREATE TABLE public.erp_history_route_logistic_cost (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	route_logistic_cost_external_id uuid NULL,
	"cost" numeric(18, 2) DEFAULT 0 NULL,
	"action" varchar NOT NULL,
	action_by uuid NOT NULL,
	"version" timestamp NULL,
	CONSTRAINT erp_history_route_logistic_cost_pkey PRIMARY KEY (id),
	CONSTRAINT uq_route_logistic_cost_version UNIQUE (route_logistic_cost_external_id, version)
);


-- public.erp_history_schedules definition

-- Drop table

-- DROP TABLE public.erp_history_schedules;

CREATE TABLE public.erp_history_schedules (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	schedule_external_id uuid NULL,
	"action" varchar NOT NULL,
	action_by uuid NOT NULL,
	action_at timestamp DEFAULT now() NULL,
	raw_data jsonb NULL,
	CONSTRAINT erp_history_schedules_pkey PRIMARY KEY (id)
);


-- public.erp_integration_api definition

-- Drop table

-- DROP TABLE public.erp_integration_api;

CREATE TABLE public.erp_integration_api (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	provider varchar(25) NOT NULL,
	access_key varchar NULL,
	refresh_key varchar NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_integration_api_pkey PRIMARY KEY (id),
	CONSTRAINT erp_integration_api_provider_key UNIQUE (provider)
);


-- public.erp_new_driver_notification definition

-- Drop table

-- DROP TABLE public.erp_new_driver_notification;

CREATE TABLE public.erp_new_driver_notification (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	user_external_id uuid NOT NULL,
	read_time timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_new_driver_notification_pkey PRIMARY KEY (id)
);


-- public.erp_notification definition

-- Drop table

-- DROP TABLE public.erp_notification;

CREATE TABLE public.erp_notification (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	user_external_id uuid NULL,
	title varchar NULL,
	body varchar NULL,
	image_url varchar NULL,
	fcm_token text NULL,
	"data" json NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	is_sent_provider bool DEFAULT false NOT NULL,
	provider int4 DEFAULT 0 NOT NULL,
	user_action varchar(50) NULL,
	is_read bool DEFAULT false NULL,
	provider_response json NULL,
	object_type varchar(50) NULL,
	object_id varchar(100) NULL,
	CONSTRAINT erp_notification_pkey PRIMARY KEY (id)
);


-- public.erp_projects definition

-- Drop table

-- DROP TABLE public.erp_projects;

CREATE TABLE public.erp_projects (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_external_id uuid NOT NULL,
	"name" varchar NOT NULL,
	start_time timestamp NULL,
	end_time timestamp NULL,
	region varchar NOT NULL,
	description varchar NULL,
	active bool NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted timestamp NULL,
	is_deleted bool DEFAULT false NOT NULL,
	code varchar NULL,
	shift_name text NULL,
	CONSTRAINT erp_projects_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_erp_projects_code ON public.erp_projects USING btree (code);


-- public.erp_register definition

-- Drop table

-- DROP TABLE public.erp_register;

CREATE TABLE public.erp_register (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	username varchar(255) NOT NULL,
	"password" varchar(255) NOT NULL,
	first_name varchar(255) NULL,
	last_name varchar(255) NULL,
	address varchar(255) NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT erp_register_pkey PRIMARY KEY (id)
);


-- public.erp_route definition

-- Drop table

-- DROP TABLE public.erp_route;

CREATE TABLE public.erp_route (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	project_external_id uuid NOT NULL,
	"name" varchar NOT NULL,
	"type" varchar NULL,
	kilometer varchar NULL,
	description varchar NULL,
	active bool DEFAULT true NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted timestamp NULL,
	is_deleted bool DEFAULT false NOT NULL,
	code varchar NULL,
	sharemap_code varchar NULL,
	route_type varchar(50) DEFAULT 'normal'::character varying NULL,
	shift_name varchar NULL,
	is_return bool DEFAULT true NULL,
	CONSTRAINT erp_route_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_erp_route_code ON public.erp_route USING btree (code);


-- public.erp_route_customer_price definition

-- Drop table

-- DROP TABLE public.erp_route_customer_price;

CREATE TABLE public.erp_route_customer_price (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_customer_route_price_external_id uuid NOT NULL,
	route_external_id uuid NOT NULL,
	model_group_external_id uuid NOT NULL,
	price numeric(18, 2) DEFAULT 0 NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	is_deleted bool DEFAULT false NOT NULL,
	calculator_external_id uuid NULL,
	CONSTRAINT erp_route_customer_price_pkey PRIMARY KEY (id)
);


-- public.erp_route_drop_point definition

-- Drop table

-- DROP TABLE public.erp_route_drop_point;

CREATE TABLE public.erp_route_drop_point (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	route_external_id uuid NULL,
	"name" varchar NOT NULL,
	"index" int4 NOT NULL,
	lat numeric(9, 6) NOT NULL,
	lng numeric(9, 6) NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	address varchar(255) NULL,
	CONSTRAINT erp_route_drop_point_pkey PRIMARY KEY (id)
);


-- public.erp_route_logistic_cost definition

-- Drop table

-- DROP TABLE public.erp_route_logistic_cost;

CREATE TABLE public.erp_route_logistic_cost (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	route_external_id uuid NOT NULL,
	model_group_external_id uuid NOT NULL,
	"cost" numeric(18, 2) DEFAULT 0 NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	is_deleted bool DEFAULT false NOT NULL,
	company_route_logistic_cost_external_id uuid NULL,
	calculator_external_id uuid NULL,
	CONSTRAINT erp_route_logistic_cost_pkey PRIMARY KEY (id),
	CONSTRAINT uq_route_model_group_company_route_logistic_cost UNIQUE (route_external_id, company_route_logistic_cost_external_id, model_group_external_id)
);


-- public.erp_route_segment definition

-- Drop table

-- DROP TABLE public.erp_route_segment;

CREATE TABLE public.erp_route_segment (
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	from_external_id uuid NOT NULL,
	to_external_id uuid NOT NULL,
	distance_km_from_previous_point numeric(8, 3) NULL,
	code varchar NULL,
	actual_driver_distance float8 NULL,
	CONSTRAINT erp_route_segment_pkey PRIMARY KEY (external_id)
);


-- public.erp_route_user definition

-- Drop table

-- DROP TABLE public.erp_route_user;

CREATE TABLE public.erp_route_user (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	route_external_id uuid NOT NULL,
	user_external_id uuid NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_route_user_pkey PRIMARY KEY (id)
);


-- public.erp_schedules definition

-- Drop table

-- DROP TABLE public.erp_schedules;

CREATE TABLE public.erp_schedules (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	first_driver_phone varchar(15) NULL,
	second_driver_phone varchar(15) NULL,
	start_time timestamp NULL,
	end_time timestamp NULL,
	note text NULL,
	status varchar NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_external_id uuid NULL,
	vehicle_external_id uuid NULL,
	first_driver_external_id uuid NULL,
	second_driver_external_id uuid NULL,
	is_valid bool DEFAULT true NULL,
	create_uid uuid NULL,
	write_uid uuid NULL,
	first_driver_info varchar NULL,
	second_driver_info varchar NULL,
	code varchar NULL,
	project_external_id uuid NULL,
	route_external_id uuid NULL,
	first_driver_name varchar NULL,
	second_driver_name varchar NULL,
	license_plate varchar NULL,
	is_cancel bool DEFAULT false NOT NULL,
	logistic_company_external_id uuid NULL,
	model_group_external_id uuid NULL,
	total_distance_km numeric(14, 2) DEFAULT 0.00 NULL,
	external_code varchar NULL,
	CONSTRAINT erp_schedules_pkey PRIMARY KEY (id),
	CONSTRAINT uq_code UNIQUE (code),
	CONSTRAINT uq_schedule_group_start_time UNIQUE (logistic_company_external_id, route_external_id, license_plate, start_time)
);
CREATE INDEX idx_erp_schedules_code ON public.erp_schedules USING btree (code);
CREATE INDEX idx_erp_schedules_start_end ON public.erp_schedules USING btree (start_time, end_time);
CREATE INDEX idx_schedules_vehicle_external ON public.erp_schedules USING btree (vehicle_external_id);


-- public.erp_schedules_customer_allowance definition

-- Drop table

-- DROP TABLE public.erp_schedules_customer_allowance;

CREATE TABLE public.erp_schedules_customer_allowance (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	schedules_customer_price_external_id uuid NOT NULL,
	company_customer_allowance_external_id uuid NOT NULL,
	quantity int4 DEFAULT 0 NULL,
	allowance_cost numeric(18, 4) DEFAULT 0 NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	template_allowance_id int4 NULL,
	CONSTRAINT erp_schedules_customer_allowance_pkey PRIMARY KEY (id),
	CONSTRAINT uq_schedules_customer_price_company_customer_allowance UNIQUE (schedules_customer_price_external_id, company_customer_allowance_external_id)
);


-- public.erp_schedules_customer_price definition

-- Drop table

-- DROP TABLE public.erp_schedules_customer_price;

CREATE TABLE public.erp_schedules_customer_price (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	schedules_external_id uuid NOT NULL,
	company_customer_revenue_external_id uuid NOT NULL,
	route_customer_price_external_id uuid NULL,
	gas_price numeric(18, 4) DEFAULT 0 NULL,
	route_price numeric(18, 4) DEFAULT 0 NULL,
	price_without_vat numeric(18, 4) DEFAULT 0 NULL,
	fee_vat numeric(18, 4) DEFAULT 0 NULL,
	total_price numeric(18, 4) DEFAULT 0 NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"version" timestamp NULL,
	allowance_pc1 numeric(18, 4) DEFAULT 0 NULL,
	allowance_pc2 numeric(18, 4) DEFAULT 0 NULL,
	total_allowance_cost numeric(18, 4) DEFAULT 0 NULL,
	other_allowance numeric(18, 4) DEFAULT 0 NULL,
	total_surcharge numeric(18, 4) DEFAULT 0 NULL,
	CONSTRAINT erp_schedules_customer_price_pkey PRIMARY KEY (id),
	CONSTRAINT uq_schedules_customer_price UNIQUE (schedules_external_id)
);


-- public.erp_schedules_customer_surcharge definition

-- Drop table

-- DROP TABLE public.erp_schedules_customer_surcharge;

CREATE TABLE public.erp_schedules_customer_surcharge (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid NOT NULL,
	schedules_customer_price_external_id uuid NOT NULL,
	template_surcharge_id int4 NOT NULL,
	surcharge numeric(18, 4) DEFAULT 0 NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT erp_schedules_customer_surcharge_pkey PRIMARY KEY (id)
);


-- public.erp_schedules_logistic_allowance definition

-- Drop table

-- DROP TABLE public.erp_schedules_logistic_allowance;

CREATE TABLE public.erp_schedules_logistic_allowance (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	schedules_logistic_cost_external_id uuid NOT NULL,
	company_logistic_allowance_external_id uuid NOT NULL,
	quantity int4 DEFAULT 0 NULL,
	allowance_cost numeric(18, 4) DEFAULT 0 NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	template_allowance_id int4 NULL,
	first_driver_external_id uuid NULL,
	second_driver_external_id uuid NULL,
	CONSTRAINT erp_schedules_logistic_allowance_pkey PRIMARY KEY (id),
	CONSTRAINT uq_schedules_logistic_cost_company_logistic_allowance UNIQUE (schedules_logistic_cost_external_id, company_logistic_allowance_external_id)
);


-- public.erp_schedules_logistic_cost definition

-- Drop table

-- DROP TABLE public.erp_schedules_logistic_cost;

CREATE TABLE public.erp_schedules_logistic_cost (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	schedules_external_id uuid NOT NULL,
	company_logistic_cost_external_id uuid NOT NULL,
	route_logistic_cost_external_id uuid NULL,
	gas_price numeric(18, 4) DEFAULT 0 NULL,
	route_cost numeric(18, 4) DEFAULT 0 NULL,
	cost_without_vat numeric(18, 4) DEFAULT 0 NULL,
	fee_vat numeric(18, 4) DEFAULT 0 NULL,
	total_cost numeric(18, 4) DEFAULT 0 NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"version" timestamp NULL,
	allowance_pc1_first_driver numeric(18, 4) DEFAULT 0 NULL,
	allowance_pc2_first_driver numeric(18, 4) DEFAULT 0 NULL,
	total_allowance_cost_first_driver numeric(18, 4) DEFAULT 0 NULL,
	other_allowance_first_driver numeric(18, 4) DEFAULT 0 NULL,
	total_driver int4 DEFAULT 0 NULL,
	allowance_pc1_second_driver numeric(18, 4) DEFAULT 0 NULL,
	allowance_pc2_second_driver numeric(18, 4) DEFAULT 0 NULL,
	total_allowance_cost_second_driver numeric(18, 4) DEFAULT 0 NULL,
	other_allowance_second_driver numeric(18, 4) DEFAULT 0 NULL,
	total_surcharge numeric(18, 4) DEFAULT 0 NULL,
	CONSTRAINT erp_schedules_logistic_cost_pkey PRIMARY KEY (id),
	CONSTRAINT uq_schedules_logistic_cost UNIQUE (schedules_external_id)
);


-- public.erp_schedules_logistic_surcharge definition

-- Drop table

-- DROP TABLE public.erp_schedules_logistic_surcharge;

CREATE TABLE public.erp_schedules_logistic_surcharge (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid NOT NULL,
	schedules_logistic_cost_external_id uuid NOT NULL,
	template_surcharge_id int4 NOT NULL,
	surcharge numeric(18, 4) DEFAULT 0 NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT erp_schedules_logistic_surcharge_pkey PRIMARY KEY (id)
);


-- public.erp_shedlock definition

-- Drop table

-- DROP TABLE public.erp_shedlock;

CREATE TABLE public.erp_shedlock (
	"name" varchar(64) NOT NULL,
	lock_until timestamp NOT NULL,
	locked_at timestamp NOT NULL,
	locked_by varchar(255) NOT NULL,
	CONSTRAINT erp_shedlock_pkey PRIMARY KEY (name)
);


-- public.erp_shifts definition

-- Drop table

-- DROP TABLE public.erp_shifts;

CREATE TABLE public.erp_shifts (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	"name" varchar NULL,
	description text NULL,
	start_time timestamp NULL,
	end_time timestamp NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted timestamp NULL,
	is_deleted bool DEFAULT false NOT NULL,
	CONSTRAINT erp_shifts_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_erp_shifts_name_fts ON public.erp_shifts USING gin (to_tsvector('simple'::regconfig, (name)::text));


-- public.erp_template_allowance definition

-- Drop table

-- DROP TABLE public.erp_template_allowance;

CREATE TABLE public.erp_template_allowance (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	"name" varchar NOT NULL,
	description varchar NULL,
	is_3pl bool DEFAULT false NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	is_multiple bool DEFAULT false NULL,
	unit varchar NULL,
	is_deleted bool DEFAULT false NULL,
	"type" int2 DEFAULT 0 NULL,
	is_special bool DEFAULT false NULL,
	CONSTRAINT erp_template_allowance_pkey PRIMARY KEY (id),
	CONSTRAINT uq_name UNIQUE (name)
);


-- public.erp_template_surcharge definition

-- Drop table

-- DROP TABLE public.erp_template_surcharge;

CREATE TABLE public.erp_template_surcharge (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"name" varchar(255) NULL,
	description varchar(255) NULL,
	unit varchar(255) DEFAULT 'VNĐ'::character varying NULL,
	is_deleted bool DEFAULT false NOT NULL,
	"type" int4 NULL,
	is_3pl bool DEFAULT false NOT NULL,
	CONSTRAINT erp_template_surcharge_pkey PRIMARY KEY (id),
	CONSTRAINT uq_template_surcharge_name UNIQUE (name)
);


-- public.erp_upload_aws definition

-- Drop table

-- DROP TABLE public.erp_upload_aws;

CREATE TABLE public.erp_upload_aws (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	url text NOT NULL,
	create_uid uuid NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_upload_aws_pkey PRIMARY KEY (id)
);


-- public.erp_user_working_routes definition

-- Drop table

-- DROP TABLE public.erp_user_working_routes;

CREATE TABLE public.erp_user_working_routes (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	route_external_id uuid NOT NULL,
	user_external_id uuid NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	logistic_company_external_id uuid NULL,
	model_group_external_id uuid NULL,
	vehicle_external_id uuid NULL,
	first_driver_name varchar NULL,
	second_driver_name varchar NULL,
	license_plate varchar NULL,
	first_driver_external_id uuid NULL,
	second_driver_external_id uuid NULL,
	start_time timestamp NULL,
	end_time timestamp NULL,
	note text NULL,
	CONSTRAINT erp_user_working_routes_pkey PRIMARY KEY (id),
	CONSTRAINT uq_user_route_company_logistic UNIQUE (route_external_id, user_external_id, logistic_company_external_id)
);


-- public.erp_vehicle definition

-- Drop table

-- DROP TABLE public.erp_vehicle;

CREATE TABLE public.erp_vehicle (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	model_id int4 NOT NULL,
	model_year int4 NULL,
	"name" varchar NOT NULL,
	license_plate varchar NOT NULL,
	state varchar NULL,
	cabin varchar NULL,
	vin_sn varchar NULL,
	color varchar NULL,
	truck_type varchar NULL,
	description text NULL,
	create_date timestamp NULL,
	write_date timestamp NULL,
	weight float8 NULL,
	width float8 NULL,
	length float8 NULL,
	height float8 NULL,
	flag_3pl bool NULL,
	active bool NULL,
	message_main_attachment_id int4 NULL,
	current_hub_id int4 NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	create_uid uuid NULL,
	write_uid uuid NULL,
	region varchar DEFAULT 'southern'::character varying NULL,
	delete_date timestamp NULL,
	delete_uid uuid NULL,
	CONSTRAINT erp_vehicle_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_vehicle_external ON public.erp_vehicle USING btree (external_id);


-- public.erp_vehicle_document definition

-- Drop table

-- DROP TABLE public.erp_vehicle_document;

CREATE TABLE public.erp_vehicle_document (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	message_main_attachment_id int4 NULL,
	truck_id int4 NOT NULL,
	profile_type_id int4 NOT NULL,
	create_uid int4 NULL,
	write_uid int4 NULL,
	"name" varchar NOT NULL,
	state varchar NOT NULL,
	kanban_state varchar NULL,
	truck_license_plate varchar NULL,
	document_type varchar NOT NULL,
	start_date date NOT NULL,
	end_date date NULL,
	note text NULL,
	is_show_button_renew bool NULL,
	is_show_button_active bool NULL,
	create_date timestamp NULL,
	write_date timestamp NULL,
	CONSTRAINT erp_vehicle_document_pkey PRIMARY KEY (id)
);
CREATE INDEX erp_vehicle_document_name_index ON public.erp_vehicle_document USING btree (name);


-- public.erp_vehicle_driver_link definition

-- Drop table

-- DROP TABLE public.erp_vehicle_driver_link;

CREATE TABLE public.erp_vehicle_driver_link (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	first_driver_external_id uuid NULL,
	second_driver_external_id uuid NULL,
	vehicle_external_id uuid NULL,
	create_uid uuid NULL,
	write_uid uuid NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_vehicle_driver_link_pkey PRIMARY KEY (id)
);


-- public.erp_vehicle_driver_mapping definition

-- Drop table

-- DROP TABLE public.erp_vehicle_driver_mapping;

CREATE TABLE public.erp_vehicle_driver_mapping (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	driver_external_id uuid NOT NULL,
	driver_phone varchar(15) NOT NULL,
	vehicle_external_id uuid NOT NULL,
	create_uid uuid NULL,
	write_uid uuid NULL,
	is_primary_driver bool DEFAULT false NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_vehicle_driver_mapping_pkey PRIMARY KEY (id)
);


-- public.erp_vehicle_history_hub definition

-- Drop table

-- DROP TABLE public.erp_vehicle_history_hub;

CREATE TABLE public.erp_vehicle_history_hub (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	message_main_attachment_id int4 NULL,
	truck_id int4 NOT NULL,
	hub_id int4 NOT NULL,
	create_uid int4 NULL,
	write_uid int4 NULL,
	"name" varchar NOT NULL,
	truck_license_plate varchar NULL,
	start_date date NOT NULL,
	end_date date NULL,
	is_active bool NULL,
	create_date timestamp NULL,
	write_date timestamp NULL,
	CONSTRAINT erp_vehicle_history_hub_pkey PRIMARY KEY (id)
);
CREATE INDEX erp_vehicle_history_hub_name_index ON public.erp_vehicle_history_hub USING btree (name);


-- public.erp_vehicle_model definition

-- Drop table

-- DROP TABLE public.erp_vehicle_model;

CREATE TABLE public.erp_vehicle_model (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	brand_id int4 NULL,
	create_uid int4 NULL,
	write_uid int4 NULL,
	"name" varchar NOT NULL,
	cabin varchar NOT NULL,
	create_date timestamp NULL,
	write_date timestamp NULL,
	weight float8 NULL,
	width float8 NULL,
	length float8 NULL,
	height float8 NULL,
	model_group_external_id uuid NULL,
	CONSTRAINT erp_vehicle_model_pkey PRIMARY KEY (id)
);


-- public.erp_vehicle_model_group definition

-- Drop table

-- DROP TABLE public.erp_vehicle_model_group;

CREATE TABLE public.erp_vehicle_model_group (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	"name" varchar NULL,
	description varchar NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted timestamp NULL,
	is_deleted bool DEFAULT false NOT NULL,
	weight int4 NULL,
	CONSTRAINT erp_vehicle_model_group_pkey PRIMARY KEY (id)
);


-- public.erp_business_cost definition

-- Drop table

-- DROP TABLE public.erp_business_cost;

CREATE TABLE public.erp_business_cost (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	config_external_id uuid NULL,
	cost_without_vat numeric(18, 2) DEFAULT 0 NOT NULL,
	fee_vat numeric(5, 4) DEFAULT 0 NULL,
	total_cost numeric(18, 2) DEFAULT 0 NULL,
	apply_year int4 NULL,
	from_date timestamp NULL,
	to_date timestamp NULL,
	create_uid uuid NULL,
	description text NULL,
	documents jsonb NULL,
	is_deleted bool DEFAULT false NOT NULL,
	deleted timestamp NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	cost_type varchar(50) NULL,
	CONSTRAINT erp_business_cost_pkey PRIMARY KEY (id),
	CONSTRAINT fk_business_cost_config FOREIGN KEY (config_external_id) REFERENCES public.erp_business_cost_config(external_id) ON DELETE SET NULL
);


-- public.erp_company definition

-- Drop table

-- DROP TABLE public.erp_company;

CREATE TABLE public.erp_company (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	"name" varchar NOT NULL,
	email varchar NULL,
	phone varchar NULL,
	mobile varchar NULL,
	company_details text NULL,
	active bool NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	logo_web varchar NULL,
	social_twitter varchar NULL,
	social_facebook varchar NULL,
	social_github varchar NULL,
	social_linkedin varchar NULL,
	social_youtube varchar NULL,
	social_instagram varchar NULL,
	country_id int4 NULL,
	vat varchar NULL,
	street varchar NULL,
	street2 varchar NULL,
	zip varchar NULL,
	city varchar NULL,
	website varchar NULL,
	state_id int4 NULL,
	code varchar NULL,
	is_primary bool DEFAULT false NULL,
	schedules_background varchar(30) NULL,
	schedules_text varchar(30) NULL,
	is_deleted bool DEFAULT false NOT NULL,
	company_type varchar NULL,
	business_type int2 DEFAULT 0 NULL,
	fee_vat numeric(5, 4) DEFAULT 0.08 NULL,
	CONSTRAINT erp_company_pkey PRIMARY KEY (id),
	CONSTRAINT uq_erp_company_code UNIQUE (code)
);


-- public.erp_country definition

-- Drop table

-- DROP TABLE public.erp_country;

CREATE TABLE public.erp_country (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	address_view_id int4 NULL,
	currency_id int4 NULL,
	phone_code int4 NULL,
	create_uid int4 NULL,
	write_uid int4 NULL,
	code varchar(2) NOT NULL,
	name_position varchar NULL,
	"name" jsonb NOT NULL,
	vat_label jsonb NULL,
	address_format text NULL,
	state_required bool NULL,
	zip_required bool NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_country_code_uniq UNIQUE (code),
	CONSTRAINT erp_country_name_uniq UNIQUE (name),
	CONSTRAINT erp_country_pkey PRIMARY KEY (id)
);


-- public.erp_country_erp_country_group_rel definition

-- Drop table

-- DROP TABLE public.erp_country_erp_country_group_rel;

CREATE TABLE public.erp_country_erp_country_group_rel (
	erp_country_id int4 NOT NULL,
	erp_country_group_id int4 NOT NULL,
	CONSTRAINT erp_country_erp_country_group_rel_pkey PRIMARY KEY (erp_country_id, erp_country_group_id)
);
CREATE INDEX erp_country_erp_country_group_erp_country_group_id_erp_coun_idx ON public.erp_country_erp_country_group_rel USING btree (erp_country_group_id, erp_country_id);


-- public.erp_country_group definition

-- Drop table

-- DROP TABLE public.erp_country_group;

CREATE TABLE public.erp_country_group (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	create_uid int4 NULL,
	write_uid int4 NULL,
	"name" jsonb NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_country_group_pkey PRIMARY KEY (id)
);


-- public.erp_country_state definition

-- Drop table

-- DROP TABLE public.erp_country_state;

CREATE TABLE public.erp_country_state (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	country_id int4 NOT NULL,
	create_uid int4 NULL,
	write_uid int4 NULL,
	"name" varchar NOT NULL,
	code varchar NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT erp_country_state_name_code_uniq UNIQUE (country_id, code),
	CONSTRAINT erp_country_state_pkey PRIMARY KEY (id)
);


-- public.erp_department definition

-- Drop table

-- DROP TABLE public.erp_department;

CREATE TABLE public.erp_department (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_id int4 NULL,
	parent_id int4 NULL,
	manager_id int4 NULL,
	master_department_id int4 NULL,
	"name" varchar NOT NULL,
	complete_name varchar NULL,
	parent_path varchar NULL,
	note text NULL,
	active bool NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	code varchar NULL,
	create_uid uuid NULL,
	write_uid uuid NULL,
	CONSTRAINT erp_department_pkey PRIMARY KEY (id)
);


-- public.erp_employee definition

-- Drop table

-- DROP TABLE public.erp_employee;

CREATE TABLE public.erp_employee (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	parent_id int4 NULL,
	coach_id int4 NULL,
	children int4 NULL,
	country_of_birth int4 NULL,
	bank_account_id int4 NULL,
	km_home_work int4 NULL,
	job_title varchar NULL,
	work_phone varchar NULL,
	mobile_phone varchar NULL,
	work_email varchar NULL,
	private_street varchar NULL,
	private_street2 varchar NULL,
	private_city varchar NULL,
	private_zip varchar NULL,
	private_phone varchar NULL,
	private_email varchar NULL,
	lang varchar NULL,
	gender varchar NULL,
	marital varchar NULL,
	place_of_birth varchar NULL,
	identification_id varchar NULL,
	passport_id varchar NULL,
	permit_no varchar NULL,
	visa_no varchar NULL,
	certificate varchar NULL,
	study_field varchar NULL,
	study_school varchar NULL,
	emergency_contact varchar NULL,
	emergency_phone varchar NULL,
	employee_type varchar NULL,
	barcode varchar NULL,
	spouse_birthdate date NULL,
	birthday date NULL,
	visa_expire date NULL,
	work_permit_expiration_date date NULL,
	departure_date date NULL,
	employee_properties jsonb NULL,
	additional_note text NULL,
	notes text NULL,
	departure_description text NULL,
	active bool NULL,
	work_permit_scheduled_activity bool NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	private_state_id int4 NULL,
	private_country_id int4 NULL,
	avatar varchar(1024) NULL,
	department_external_id uuid NULL,
	user_external_id uuid NULL,
	company_external_id uuid NULL,
	create_uid uuid NULL,
	write_uid uuid NULL,
	first_name varchar(50) NULL,
	last_name varchar(50) NULL,
	region varchar(100) NULL,
	CONSTRAINT erp_employee_pkey PRIMARY KEY (id)
);


-- public.erp_users definition

-- Drop table

-- DROP TABLE public.erp_users;

CREATE TABLE public.erp_users (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	external_id uuid DEFAULT gen_random_uuid() NOT NULL,
	company_id int4 NULL,
	partner_id int4 NULL,
	active bool DEFAULT true NULL,
	first_login bool DEFAULT true NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"role" varchar NOT NULL,
	username varchar NOT NULL,
	"password" varchar NULL,
	create_uid uuid NULL,
	write_uid uuid NULL,
	fcm_token text NULL,
	CONSTRAINT erp_users_pkey PRIMARY KEY (id),
	CONSTRAINT unique_username UNIQUE (username)
);


-- public.erp_company foreign keys

ALTER TABLE public.erp_company ADD CONSTRAINT erp_company_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.erp_country(id) ON DELETE RESTRICT;
ALTER TABLE public.erp_company ADD CONSTRAINT erp_partner_state_id_fkey FOREIGN KEY (state_id) REFERENCES public.erp_country_state(id) ON DELETE RESTRICT;


-- public.erp_country foreign keys

ALTER TABLE public.erp_country ADD CONSTRAINT erp_country_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.erp_users(id) ON DELETE SET NULL;
ALTER TABLE public.erp_country ADD CONSTRAINT erp_country_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.erp_users(id) ON DELETE SET NULL;


-- public.erp_country_erp_country_group_rel foreign keys

ALTER TABLE public.erp_country_erp_country_group_rel ADD CONSTRAINT erp_country_erp_country_group_rel_erp_country_group_id_fkey FOREIGN KEY (erp_country_group_id) REFERENCES public.erp_country_group(id) ON DELETE CASCADE;
ALTER TABLE public.erp_country_erp_country_group_rel ADD CONSTRAINT erp_country_erp_country_group_rel_erp_country_id_fkey FOREIGN KEY (erp_country_id) REFERENCES public.erp_country(id) ON DELETE CASCADE;


-- public.erp_country_group foreign keys

ALTER TABLE public.erp_country_group ADD CONSTRAINT erp_country_group_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.erp_users(id) ON DELETE SET NULL;
ALTER TABLE public.erp_country_group ADD CONSTRAINT erp_country_group_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.erp_users(id) ON DELETE SET NULL;


-- public.erp_country_state foreign keys

ALTER TABLE public.erp_country_state ADD CONSTRAINT erp_country_state_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.erp_country(id) ON DELETE RESTRICT;
ALTER TABLE public.erp_country_state ADD CONSTRAINT erp_country_state_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.erp_users(id) ON DELETE SET NULL;
ALTER TABLE public.erp_country_state ADD CONSTRAINT erp_country_state_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.erp_users(id) ON DELETE SET NULL;


-- public.erp_department foreign keys

ALTER TABLE public.erp_department ADD CONSTRAINT erp_department_company_id FOREIGN KEY (company_id) REFERENCES public.erp_company(id);


-- public.erp_employee foreign keys

ALTER TABLE public.erp_employee ADD CONSTRAINT erp_employee_coach_id_fkey FOREIGN KEY (coach_id) REFERENCES public.erp_employee(id) ON DELETE SET NULL;
ALTER TABLE public.erp_employee ADD CONSTRAINT erp_employee_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.erp_employee(id) ON DELETE SET NULL;
ALTER TABLE public.erp_employee ADD CONSTRAINT erp_employee_private_country_id_fkey FOREIGN KEY (private_country_id) REFERENCES public.erp_country(id) ON DELETE SET NULL;
ALTER TABLE public.erp_employee ADD CONSTRAINT erp_employee_private_state_id_fkey FOREIGN KEY (private_state_id) REFERENCES public.erp_country_state(id) ON DELETE SET NULL;


-- public.erp_users foreign keys

ALTER TABLE public.erp_users ADD CONSTRAINT erp_users_company_id FOREIGN KEY (company_id) REFERENCES public.erp_company(id);