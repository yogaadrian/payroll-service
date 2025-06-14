-- Migration: 005_create_reimbursement_table.down.sql
-- Drop reimbursement table

DROP TRIGGER IF EXISTS update_reimbursement_updated_at ON reimbursement;
DROP TABLE IF EXISTS reimbursement;