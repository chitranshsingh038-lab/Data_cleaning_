# Data_cleaning_

# Coffee Sales Data Cleaning & Preparation

## Project Overview

This project focuses on cleaning and preparing a Coffee Sales dataset for further data analysis and visualization.

The project was completed as part of my **Data Analyst Internship at SWYNEX Technologies**.

The main objective was to identify and handle common data-quality issues such as missing values, inconsistent formatting, duplicate records, and incorrect data types using **MySQL**.

---

## Objectives

The key objectives of this project were:

- Inspect the structure and quality of the raw dataset
- Identify missing and NULL values
- Remove unnecessary spaces from text fields
- Standardize text values
- Check for inconsistent categorical values
- Check for duplicate records
- Convert the date column from text format to a proper `DATE` datatype
- Prepare the cleaned dataset for further analysis and visualization

---

## Dataset

**Dataset:** Coffee Sales Dataset

The dataset contains coffee transaction information, including:

- Date
- Date & Time
- Payment Method
- Card Information
- Transaction Amount
- Coffee Name

The dataset was obtained from a publicly available dataset source.

> **Note:** The raw dataset is kept separate from the cleaned dataset to preserve the original data.

---

## 🛠️ Tools & Technologies

- **MySQL**
- **MySQL Workbench**
- **SQL**
- **GitHub**

---

## Data Cleaning Process

### 1. Text Standardization

Removed unnecessary spaces and standardized text values using `TRIM()` and `LOWER()`.

Example:

sql
UPDATE coffee_sales
SET date_ = TRIM(LOWER(date_)),
    datetime_ = TRIM(LOWER(datetime_)),
    cash_type = TRIM(LOWER(cash_type)),
    money = TRIM(money),
    coffee_name = TRIM(LOWER(coffee_name));
    
2. Missing Value Check

Checked the dataset for NULL and blank values across important columns such as:

- Date
- Date & Time
- Cash Type
- Card
- Money
- Coffee Name

SQL used:

sql

SELECT *
FROM coffee_sales
WHERE date_ IS NULL OR TRIM(date_) = ''
   OR datetime_ IS NULL OR TRIM(datetime_) = ''
   OR cash_type IS NULL OR TRIM(cash_type) = ''
   OR card_ IS NULL OR TRIM(card_) = ''
   OR money IS NULL OR TRIM(money) = ''
   OR coffee_name IS NULL OR TRIM(coffee_name) = '';

3. Handling Missing Card Values

For cash transactions where the card_ column was empty or NULL, the value was standardized as payment_by_cash.

sql

UPDATE coffee_sales
SET card_ = 'payment_by_cash'
WHERE cash_type = 'cash'
  AND (card_ IS NULL OR TRIM(card_) = '');

  4. Categorical Data Validation

Checked the cash_type column to identify inconsistent or misspelled payment methods.

sql

SELECT 
    cash_type,
    COUNT(*) AS total_transactions
FROM coffee_sales
GROUP BY cash_type
ORDER BY total_transactions DESC;

5. Duplicate Record Check

Checked for exact duplicate transactions using the relevant columns:

sql

SELECT 
    date_,datetime_,cash_type,
    card_,money,coffee_name,
    COUNT(*) AS duplicate_count
FROM coffee_sales
GROUP BY 
    date_,datetime_,cash_type,
    card_,money,coffee_name
HAVING COUNT(*) > 1;

6. Date Conversion

The original date_ column was stored as text in DD-MM-YYYY format.
The text values were converted into a proper MySQL DATE datatype using STR_TO_DATE().

sql

UPDATE coffee_sales
SET dates_ = STR_TO_DATE(TRIM(date_), '%d-%m-%Y');
