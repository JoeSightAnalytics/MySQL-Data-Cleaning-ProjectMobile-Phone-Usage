# World Mobile Phone Usage: Data Cleaning Project

## Overview

This project focuses on cleaning and preparing a dataset about global mobile phone usage using MySQL. The raw data required several cleaning steps to ensure accuracy and usability for analysis and visualization.

## Objectives

- Identify and remove duplicate records
- Standardize column names and data types
- Remove redundant columns
- Handle null and blank values
- Prepare the dataset for further analysis by ranking entries

## Dataset

The dataset (`mobile_phone_usage`) contains information on mobile phone usage by country, including columns for country name, usage value, date of information, and region.

## Data Cleaning Steps

### 1. Removing Duplicates

Used a Common Table Expression (CTE) with `ROW_NUMBER()` to check for duplicate records based on key columns. No duplicates were found in this dataset.

```sql
WITH Duplicate_cte AS (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY name, slug, value, date_of_information, region ORDER BY name) AS Row_num
  FROM mobile_phone_usage
)
SELECT *
FROM Duplicate_cte
WHERE Row_num > 1;
```

### 2. Standardizing the Dataset

- **Renamed Columns:** Changed the first column name from an encoded format to `Country`.
- **Checked for Redundant Columns:** Compared `Country` and `slug` columns, found they were identical, and dropped the redundant `slug` column.
- **Standardized Data Types:** Converted the `value` column (mobile phone usage) from text to integer. Removed commas from numbers before conversion.

```sql
ALTER TABLE mobile_phone_usage RENAME COLUMN name TO Country;
ALTER TABLE mobile_phone_usage DROP COLUMN slug;
UPDATE mobile_phone_usage SET value = REPLACE(value, ',', '');
ALTER TABLE mobile_phone_usage MODIFY COLUMN value BIGINT;
```

### 3. Handling Null and Blank Values

- Queried for null or blank values in all major columns.
- Explicitly removed records where `value` was null or blank, as these would affect analyses and visualizations.
- Special case: Removed rows for "Wallis and Futuna" where value was zero, after backing up original data.

```sql
DELETE FROM mobile_phone_usage WHERE value IS NULL OR value = '';
```

### 4. Ranking the Data

- Added a `Rank` column to the table and populated it based on descending order of usage value, to aid in data visualization.

```sql
ALTER TABLE mobile_phone_usage ADD COLUMN Rank INT;
SET @rank = 0;
UPDATE mobile_phone_usage
SET Rank = (@rank := @rank + 1)
ORDER BY value DESC;
```

## How to Reproduce

1. **Set up MySQL and create the database:**
    ```sql
    CREATE DATABASE World_Mobile_Phone_Usage;
    USE World_Mobile_Phone_Usage;
    ```

2. **Import your raw data into a table named `mobile_phone_usage`.**

3. **Run the cleaning steps as shown above, or execute the provided SQL script:**
    - `Mobile Phone Usage Project.sql`

4. **Query the cleaned and ranked data:**
    ```sql
    SELECT * FROM mobile_phone_usage ORDER BY Rank ASC;
    ```

## Notes

- Always back up your raw data before performing deletions or irreversible changes.
- This project emphasizes repeatability and transparency in the data cleaning process.

## Contact

For questions or suggestions, please contact osasuyiroyaljoe@gmail.com
