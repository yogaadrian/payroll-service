-- Migration: 005_create_reimbursement_table.up.sql
-- Create reimbursement table

CREATE TABLE reimbursement (
    id SERIAL PRIMARY KEY,
    amount INTEGER NOT NULL,
    status SMALLINT NOT NULL DEFAULT 1, -- 1: created, 2: completed (validated at application layer)
    description TEXT NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_reimbursement_user_created ON reimbursement (user_id, created_at);
CREATE INDEX idx_reimbursement_created_at ON reimbursement (created_at);

-- Create trigger to update updated_at timestamp
CREATE TRIGGER update_reimbursement_updated_at 
    BEFORE UPDATE ON reimbursement 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();