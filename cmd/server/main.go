package main

import (
	"log"
	"net/http"
	"os"

	"payroll-service/internal/database"
	"payroll-service/modules/healthz"

	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables from .env file
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using system environment variables")
	}

	// Initialize database connection
	db, err := database.Connect()
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
	defer db.Close()

	// Use blank identifier for now, will pass to handlers later
	_ = db

	r := mux.NewRouter()

	// Register healthz module routes
	healthz.RegisterRoutes(r)

	// Get server port from environment variable
	port := os.Getenv("SERVER_PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Payroll service starting on :%s", port)
	if err := http.ListenAndServe(":"+port, r); err != nil {
		log.Fatal("Server failed to start:", err)
	}
}
