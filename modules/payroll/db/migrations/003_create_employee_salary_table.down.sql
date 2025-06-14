-- Migration: 003_create_employee_salary_table.down.sql
-- Drop employee_salary table

DROP TRIGGER IF EXISTS update_employee_salary_updated_at ON employee_salary;
DROP TABLE IF EXISTS employee_salary;