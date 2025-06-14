package main

import (
	"log"
	"net/http"

	"payroll-service/modules/healthz"

	"github.com/gorilla/mux"
)

func main() {
	r := mux.NewRouter()

	// Register health check handler
	r.HandleFunc("/health", healthz.HealthHandler).Methods("GET")

	log.Println("Payroll service starting on :8080")
	if err := http.ListenAndServe(":8080", r); err != nil {
		log.Fatal("Server failed to start:", err)
	}
}
