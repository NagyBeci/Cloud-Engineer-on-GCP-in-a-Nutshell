# SQL Basics in GCP

## Structured Data and Databases
- **Structured Data**: Organized into rows and columns (tables).  
- **Unstructured Data** (e.g. images): Not directly compatible with SQL; use services like Cloud Vision.  
- **Databases**: Collections of tables. In many SQL tasks, you’ll query one or multiple tables rather than an entire database.

## SELECT and FROM
- **SELECT**: Specify which columns to retrieve.  
- **FROM**: Specify the table(s) you’re querying.  
- **Example**:  
  ```sql
  SELECT user, shipped
  FROM example_table
  ```

## WHERE
- **Purpose**: Filter results based on specific criteria.  
- **Example**:  
  ```sql
  SELECT user
  FROM example_table
  WHERE shipped = 'YES'
  ```

## GROUP BY
- **Purpose**: Aggregate rows with shared column values; returns unique groups.  
- **Example**: Group by a station name to see unique stations.

## COUNT
- **Purpose**: Return the number of rows matching certain criteria. Often used with **GROUP BY**.  
- **Example**:  
  ```sql
  SELECT start_station_name, COUNT(*) AS total_rides
  FROM bikeshare_table
  GROUP BY start_station_name
  ```

## AS
- **Purpose**: Create an alias for a column or table (renames in query results).  
- **Example**:  
  ```sql
  SELECT start_station_name AS station, COUNT(*) AS total_rides
  ```

## ORDER BY
- **Purpose**: Sort results in ascending (`ASC`) or descending (`DESC`) order.  
- **Examples**:  
  - Alphabetically:  
    ```sql
    ORDER BY start_station_name ASC
    ```  
  - Numerically from lowest to highest:  
    ```sql
    ORDER BY total_rides ASC
    ```  
  - Numerically from highest to lowest:  
    ```sql
    ORDER BY total_rides DESC
    ```
```
```md
# More SQL Concepts and Syntax

## DISTINCT
- **Purpose**: Retrieve unique values from a column.
```sql
SELECT DISTINCT column_name
FROM table_name;
```

## LIMIT
- **Purpose**: Limit the number of rows returned.
```sql
SELECT *
FROM table_name
LIMIT 10;
```

## HAVING
- **Purpose**: Filter grouped results (used after `GROUP BY`).
```sql
SELECT column_name, COUNT(*)
FROM table_name
GROUP BY column_name
HAVING COUNT(*) > 10;
```

## JOINS
- **INNER JOIN**: Returns rows with matching values in both tables.
  ```sql
  SELECT a.col, b.col
  FROM tableA a
  INNER JOIN tableB b ON a.id = b.id;
  ```
- **LEFT JOIN**: Returns all rows from the left table, plus matched rows from the right.
  ```sql
  SELECT a.col, b.col
  FROM tableA a
  LEFT JOIN tableB b ON a.id = b.id;
  ```
- **RIGHT JOIN**: Returns all rows from the right table, plus matched rows from the left.
  ```sql
  SELECT a.col, b.col
  FROM tableA a
  RIGHT JOIN tableB b ON a.id = b.id;
  ```
- **FULL OUTER JOIN**: Returns all rows from both tables, matching when possible.
  ```sql
  SELECT a.col, b.col
  FROM tableA a
  FULL JOIN tableB b ON a.id = b.id;
  ```

## UNION and UNION ALL
- **UNION**: Combines results from two queries and removes duplicates.
  ```sql
  SELECT col FROM tableA
  UNION
  SELECT col FROM tableB;
  ```
- **UNION ALL**: Combines results from two queries, keeping duplicates.
  ```sql
  SELECT col FROM tableA
  UNION ALL
  SELECT col FROM tableB;
  ```

## CASE
- **Purpose**: Conditional logic within queries.
```sql
SELECT
  CASE
    WHEN shipped = 'YES' THEN 'Shipped'
    ELSE 'Not Shipped'
  END AS shipment_status
FROM example_table;
```

## Subqueries
- **Purpose**: Nest one query within another (often in the `FROM` or `WHERE` clause).
```sql
SELECT main_table.col
FROM (
    SELECT col
    FROM tableA
    WHERE condition
) AS main_table
WHERE main_table.col > 100;
```

## WITH (Common Table Expressions)
- **Purpose**: Name a subquery for cleaner queries.
```sql
WITH filtered_data AS (
  SELECT *
  FROM tableA
  WHERE condition
)
SELECT *
FROM filtered_data
WHERE other_condition;
```

## Window Functions
- **Purpose**: Perform calculations across sets of rows related to the current row (e.g., running totals).
```sql
SELECT
  user,
  COUNT(*) OVER (PARTITION BY user ORDER BY date) AS running_total
FROM example_table;
```

Use these techniques to refine your queries, optimize performance, and derive more complex insights from your data!
```