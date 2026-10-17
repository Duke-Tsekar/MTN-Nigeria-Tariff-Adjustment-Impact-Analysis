
/*
===============================================================================
MTN 2025 Price Adjustment Analysis
Star Schema — Current Production Schema
===============================================================================

SQL Dialect: PostgreSQL
Purpose:
    Creates the database schema for the MTN 2025 data price hike analysis.

    The schema is designed to analyse:
        - Customer purchasing behaviour
        - Transaction volume and revenue
        - Plan price and data allowance changes
        - Subscription status
        - Plan migrations
        - Pre-hike vs post-hike performance

Data Model:

    dim_customers
        │
        ├───────────────┐
        │               │
        ▼               ▼
fact_subscriptions   fact_transactions
        │               │
        ├───────┐       │
        │       │       │
        ▼       ▼       ▼
dim_plans   dim_service_types
                    │
                    │
                dim_plans

    dim_date is used to provide calendar and hike-period attributes
    for transaction analysis.

Key Business Rules:

    1. A customer can have multiple subscriptions/services.
    2. A subscription belongs to one service type and one plan.
    3. A customer can make multiple transactions against a subscription.
    4. Plans contain both pre-hike and post-hike pricing/data information.
    5. Discontinued plans may have a post_effective_to date indicating
       the final date on which the post-hike plan was available.
    6. Subscription migration is represented through self-referencing
       foreign keys.
    7. Migration foreign keys are DEFERRABLE because both sides of a
       migration relationship may need to be inserted within the same
       transaction.

SQL Objects Created:
    - 4 Dimension tables
    - 2 Fact tables
    - Primary keys
    - Foreign keys
    - Self-referencing migration constraints
    - Analytical indexes

===============================================================================
*/


/*
===============================================================================
1. CLEAN UP EXISTING TABLES
===============================================================================
*/

DROP TABLE IF EXISTS fact_transactions CASCADE;
DROP TABLE IF EXISTS fact_subscriptions CASCADE;
DROP TABLE IF EXISTS dim_plans CASCADE;
DROP TABLE IF EXISTS dim_service_types CASCADE;
DROP TABLE IF EXISTS dim_customers CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;


/*
===============================================================================
2. DIMENSION: SERVICE TYPES
===============================================================================

Purpose:
    Stores the types of services offered by MTN.

Current service categories include:
    - Fibre
    - Mobile SIM
    - Fixed Broadband

The Fixed Broadband service type covers:
    - 4G MiFi
    - 4G Router
    - 5G Router

These are grouped together because they use the same broadband
plan pricing structure in this project.

===============================================================================
*/

CREATE TABLE dim_service_types (
    service_type_id     SMALLINT PRIMARY KEY,
    service_type_name   VARCHAR(50) NOT NULL,
    service_category    VARCHAR(20) NOT NULL
);


/*
===============================================================================
3. DIMENSION: PLANS
===============================================================================

Purpose:
    Stores the MTN plans used in the analysis together with their
    pre-hike and post-hike pricing and data allowance.

Plan attributes:

    data_gb_pre
        Data allowance before the tariff adjustment.

    data_gb_post
        Data allowance after the tariff adjustment.

    price_pre
        Price before the tariff adjustment.

    price_post
        Price after the tariff adjustment.

    is_price_estimated
        Indicates whether the recorded price is estimated.

    pct_change
        Percentage change in plan price.

    data_pct_change
        Percentage change in data allowance.

    plan_status
        Describes the plan's status across the tariff adjustment.

    post_effective_to
        For plans that were withdrawn after the tariff adjustment,
        records the final date on which the post-hike price was sold.

===============================================================================
*/

CREATE TABLE dim_plans (
    plan_id              INTEGER PRIMARY KEY,
    service_type_id      SMALLINT NOT NULL,
    plan_code            VARCHAR(30) NOT NULL,
    plan_name            VARCHAR(60) NOT NULL,
    frequency            VARCHAR(20) NOT NULL,
    data_gb_pre          NUMERIC(10,2),
    data_gb_post         NUMERIC(10,2),
    price_pre            NUMERIC(12,2),
    price_post           NUMERIC(12,2),
    is_price_estimated   BOOLEAN NOT NULL DEFAULT FALSE,
    pct_change           NUMERIC(6,1),
    data_pct_change      NUMERIC(6,1),
    plan_status          VARCHAR(20) NOT NULL,
    post_effective_to    DATE,

    CONSTRAINT dim_plans_service_type_id_fkey
        FOREIGN KEY (service_type_id)
        REFERENCES dim_service_types(service_type_id)
);


/*
===============================================================================
4. DIMENSION: CUSTOMERS
===============================================================================

Purpose:
    Stores customer demographic and registration attributes used
    for customer-level behavioural analysis.

===============================================================================
*/

CREATE TABLE dim_customers (
    customer_id        INTEGER PRIMARY KEY,
    state              VARCHAR(30) NOT NULL,
    customer_segment   VARCHAR(20) NOT NULL,
    age_bracket        VARCHAR(10) NOT NULL,
    registration_date  DATE NOT NULL
);


/*
===============================================================================
5. DIMENSION: DATE
===============================================================================

Purpose:
    Provides calendar attributes and identifies whether a date falls
    before or after the MTN tariff adjustment.

Analysis window:
    1 December 2024 - 30 April 2025

date_id:
    Stored as YYYYMMDD.

is_post_hike:
    FALSE = pre-hike
    TRUE  = post-hike

hike_period_label:
    'Pre-Hike'
    'Post-Hike'

===============================================================================
*/

CREATE TABLE dim_date (
    date_id             INTEGER PRIMARY KEY,
    full_date           DATE NOT NULL,
    year                SMALLINT NOT NULL,
    month               SMALLINT NOT NULL,
    month_name          VARCHAR(12) NOT NULL,
    day                 SMALLINT NOT NULL,
    day_of_week         VARCHAR(10) NOT NULL,
    is_post_hike        BOOLEAN NOT NULL,
    hike_period_label   VARCHAR(10) NOT NULL
);


/*
===============================================================================
6. FACT: SUBSCRIPTIONS
===============================================================================

Purpose:
    Represents customer subscriptions/services.

Grain:
    One row represents one customer subscription.

A customer can therefore have multiple subscriptions, for example:
    - Mobile SIM
    - Fixed Broadband

Subscription status:
    - Active
    - Churned
    - Migrated

Migration logic:

    When a customer's subscription is migrated from one plan to another,
    the original subscription and the new subscription are represented
    as separate rows.

    migrated_to_subscription_id
        Points from the original subscription to the new subscription.

    migrated_from_subscription_id
        Points from the new subscription back to the original subscription.

These relationships are self-referencing and DEFERRABLE so that
migration records can be inserted within the same transaction.

value_tier:
    Used to classify the value of subscriptions involved in the
    migration analysis.

===============================================================================
*/

CREATE TABLE fact_subscriptions (
    subscription_id                  INTEGER PRIMARY KEY,
    customer_id                      INTEGER NOT NULL,
    service_type_id                  SMALLINT NOT NULL,
    plan_id                           INTEGER NOT NULL,
    activation_date                  DATE NOT NULL,
    status                            VARCHAR(10) NOT NULL,
    value_tier                        VARCHAR(4),
    migrated_to_subscription_id       INTEGER,
    migrated_from_subscription_id     INTEGER,

    CONSTRAINT fact_subscriptions_customer_id_fkey
        FOREIGN KEY (customer_id)
        REFERENCES dim_customers(customer_id),

    CONSTRAINT fact_subscriptions_service_type_id_fkey
        FOREIGN KEY (service_type_id)
        REFERENCES dim_service_types(service_type_id),

    CONSTRAINT fact_subscriptions_plan_id_fkey
        FOREIGN KEY (plan_id)
        REFERENCES dim_plans(plan_id),

    CONSTRAINT fact_subscriptions_migrated_to_subscription_id_fkey
        FOREIGN KEY (migrated_to_subscription_id)
        REFERENCES fact_subscriptions(subscription_id)
        DEFERRABLE INITIALLY DEFERRED,

    CONSTRAINT fact_subscriptions_migrated_from_subscription_id_fkey
        FOREIGN KEY (migrated_from_subscription_id)
        REFERENCES fact_subscriptions(subscription_id)
        DEFERRABLE INITIALLY DEFERRED
);


/*
===============================================================================
7. FACT: TRANSACTIONS
===============================================================================

Purpose:
    Stores customer purchasing activity.

Grain:
    One row represents one customer transaction.

Transactions include:
    - Renewals
    - Top-ups
    - Bundle/add-on purchases

Key measures:
    data_purchased_gb
    data_consumed_gb
    amount_ngn

The is_post_hike field identifies whether the transaction occurred
before or after the tariff adjustment.

===============================================================================
*/

CREATE TABLE fact_transactions (
    transaction_id       BIGINT PRIMARY KEY,
    subscription_id      INTEGER NOT NULL,
    customer_id          INTEGER NOT NULL,
    service_type_id      SMALLINT NOT NULL,
    plan_id              INTEGER NOT NULL,
    transaction_date     DATE NOT NULL,
    is_post_hike         BOOLEAN NOT NULL,
    transaction_type     VARCHAR(30) NOT NULL,
    channel              VARCHAR(20) NOT NULL,
    data_purchased_gb    NUMERIC(10,2) NOT NULL,
    data_consumed_gb     NUMERIC(10,2) NOT NULL,
    amount_ngn           NUMERIC(12,2) NOT NULL,

    CONSTRAINT fact_transactions_subscription_id_fkey
        FOREIGN KEY (subscription_id)
        REFERENCES fact_subscriptions(subscription_id),

    CONSTRAINT fact_transactions_customer_id_fkey
        FOREIGN KEY (customer_id)
        REFERENCES dim_customers(customer_id),

    CONSTRAINT fact_transactions_service_type_id_fkey
        FOREIGN KEY (service_type_id)
        REFERENCES dim_service_types(service_type_id),

    CONSTRAINT fact_transactions_plan_id_fkey
        FOREIGN KEY (plan_id)
        REFERENCES dim_plans(plan_id)
);


/*
===============================================================================
8. ANALYTICAL INDEXES
===============================================================================

Indexes are created on frequently filtered, joined, and grouped columns
to support the analytical queries used in the project.

===============================================================================
*/

-- Transaction analysis
CREATE INDEX idx_tx_date
    ON fact_transactions (transaction_date);

CREATE INDEX idx_tx_post_hike
    ON fact_transactions (is_post_hike);

CREATE INDEX idx_tx_customer
    ON fact_transactions (customer_id);

CREATE INDEX idx_tx_plan
    ON fact_transactions (plan_id);

CREATE INDEX idx_tx_service_type
    ON fact_transactions (service_type_id);


-- Subscription analysis
CREATE INDEX idx_sub_customer
    ON fact_subscriptions (customer_id);

CREATE INDEX idx_sub_status
    ON fact_subscriptions (status);

CREATE INDEX idx_sub_service_type
    ON fact_subscriptions (service_type_id);

CREATE INDEX idx_sub_migrated_from
    ON fact_subscriptions (migrated_from_subscription_id);


-- Plan analysis
CREATE INDEX idx_plan_status
    ON dim_plans (plan_status);


/*
===============================================================================
END OF SCHEMA
===============================================================================
*/

