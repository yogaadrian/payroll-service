-- Migration: 004_create_attendance_table.down.sql
-- Drop attendance table

DROP TRIGGER IF EXISTS update_attendance_updated_at ON attendance;
DROP TABLE IF EXISTS attendance;