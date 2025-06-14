-- Migration: 004_create_attendance_table.up.sql
-- Create attendance table

CREATE TABLE attendance (
    id SERIAL PRIMARY KEY,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    status SMALLINT NOT NULL DEFAULT 1, -- 1: created, 2: completed (validated at application layer)
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_attendance_user_composite ON attendance (user_id, start_time, end_time, status);

-- Create trigger to update updated_at timestamp
CREATE TRIGGER update_attendance_updated_at 
    BEFORE UPDATE ON attendance 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();