--Creating 'staging' schema
CREATE SCHEMA IF NOT EXISTS staging;
ALTER TABLE  public.retail_table SET SCHEMA staging;
ALTER TABLE staging.retail_table RENAME TO retail_raw;

ALTER SEQUENCE staging.retail_table_row_no_seq
RENAME TO retail_raw_row_no_seq;

--Creating 'analytics' schema
CREATE SCHEMA IF NOT EXISTS analytics;