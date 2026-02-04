CREATE DATABASE insurance_analytics;
USE insurance_analytics;
SELECT DATABASE();

CREATE TABLE insurance_master (
    client_name VARCHAR(100),
    policy_number VARCHAR(50),
    policy_status VARCHAR(20),

    policy_start_date DATE,
    policy_end_date DATE,

    product_group VARCHAR(50),
    product_sub_group VARCHAR(50),
    solution_group VARCHAR(50),
    specialty VARCHAR(50),

    account_exe_id INT,
    exe_name VARCHAR(100),
    employee_name VARCHAR(100),
    new_role VARCHAR(50),

    branch_name VARCHAR(50),
    branch VARCHAR(50),

    income_class VARCHAR(30),
    amount DECIMAL(15,2),
    premium_amount DECIMAL(15,2),
    revenue_amount DECIMAL(15,2),

    income_due_date DATE,
    revenue_transaction_type VARCHAR(50),

    renewal_status VARCHAR(30),
    lapse_reason VARCHAR(100),
    last_updated_date DATE,

    opportunity_id VARCHAR(50),
    opportunity_name VARCHAR(100),
    stage VARCHAR(30),
    closing_date DATE,

    risk_details VARCHAR(255),

    invoice_number VARCHAR(50),
    invoice_date DATE,

    meeting_date DATE,
    global_attendees VARCHAR(100),

    new_budget DECIMAL(15,2),
    cross_sell_budget DECIMAL(15,2),
    renewal_budget DECIMAL(15,2)
);
SHOW TABLES;

SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'PATH_TO_CSV/dashboard_master_dataset.csv'
INTO TABLE insurance_master
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_rows
FROM insurance_master;

SELECT COUNT(DISTINCT policy_number) AS total_policies
FROM insurance_master;

SELECT COUNT(DISTINCT client_name) AS total_clients
FROM insurance_master;

SELECT renewal_status, COUNT(*) AS count
FROM insurance_master
GROUP BY renewal_status;

SELECT SUM(amount) AS total_premium
FROM insurance_master;
commit;

SELECT COUNT(*) AS total_records
FROM insurance_master;

SELECT
    CASE WHEN COUNT(*) = COUNT(policy_number) THEN 'No Missing Values' ELSE 'Has Missing Values' END AS policy_check,
    CASE WHEN COUNT(*) = COUNT(client_name) THEN 'No Missing Values' ELSE 'Has Missing Values' END AS client_check,
    CASE WHEN COUNT(*) = COUNT(amount) THEN 'No Missing Values' ELSE 'Has Missing Values' END AS amount_check
FROM insurance_master;

SELECT branch_name, SUM(amount) AS total_amount
FROM insurance_master
GROUP BY branch_name
ORDER BY total_amount DESC
LIMIT 5;

SELECT policy_status, COUNT(*) AS policy_count
FROM insurance_master
GROUP BY policy_status;

SELECT renewal_status, COUNT(*) AS count
FROM insurance_master
GROUP BY renewal_status;

SELECT YEAR(policy_start_date) AS year, COUNT(*) AS policies_started
FROM insurance_master
GROUP BY YEAR(policy_start_date)
ORDER BY year;

SELECT YEAR(policy_start_date) AS year, SUM(amount) AS total_amount
FROM insurance_master
GROUP BY YEAR(policy_start_date)
ORDER BY year;

CREATE VIEW vw_insurance_kpis AS
SELECT
    COUNT(DISTINCT policy_number) AS total_policies,
    COUNT(DISTINCT client_name) AS total_clients,
    SUM(amount) AS total_premium
FROM insurance_master;
SELECT * FROM vw_insurance_kpis;

CREATE VIEW vw_branch_performance AS
SELECT
    branch_name,
    COUNT(DISTINCT policy_number) AS policy_count,
    SUM(amount) AS total_amount
FROM insurance_master
GROUP BY branch_name;

SELECT * FROM vw_branch_performance;
commit;

DELIMITER $$

CREATE PROCEDURE get_total_policies()
BEGIN
    SELECT COUNT(DISTINCT policy_number) AS total_policies
    FROM insurance_master;
END $$

DELIMITER ;
CALL get_total_policies();
commit;


