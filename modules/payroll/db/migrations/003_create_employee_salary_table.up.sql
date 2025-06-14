-- Migration: 003_create_employee_salary_table.up.sql
-- Create employee_salary table

CREATE TABLE employee_salary (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    salary_per_hour INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index
CREATE INDEX idx_employee_salary_user_id ON employee_salary (user_id);

-- Create trigger to update updated_at timestamp
CREATE TRIGGER update_employee_salary_updated_at 
    BEFORE UPDATE ON employee_salary 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();