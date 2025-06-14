-- Migration: 002_create_users_table.down.sql
-- Drop users table

DROP TRIGGER IF EXISTS update_users_updated_at ON users;
DROP TABLE IF EXISTS users;