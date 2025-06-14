-- Migration: 001_create_payroll_table.down.sql
-- Drop payroll table

DROP TRIGGER IF EXISTS update_payroll_updated_at ON payroll;
DROP FUNCTION IF EXISTS update_updated_at_column();
DROP TABLE IF EXISTS payroll;