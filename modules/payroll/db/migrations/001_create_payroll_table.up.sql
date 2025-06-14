-- Migration: 001_create_payroll_table.up.sql
-- Create payroll table

CREATE TABLE payroll (
    id SERIAL PRIMARY KEY,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1, -- 1: created, 2: processed (validated at application layer)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_payroll_date_range ON payroll (start_date, end_date);
CREATE INDEX idx_payroll_end_date ON payroll (end_date);

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_payroll_updated_at 
    BEFORE UPDATE ON payroll 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();