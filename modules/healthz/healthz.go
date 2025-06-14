package healthz

import (
	"net/http"
	"payroll-service/modules/healthz/internal/handlers"

	"github.com/gorilla/mux"
)

// RegisterRoutes registers all health check routes to the provided router
func RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/health", handlers.HealthHandler).Methods("GET")
}

// HealthHandler exposes the health check handler (kept for backward compatibility)
func HealthHandler(w http.ResponseWriter, r *http.Request) {
	handlers.HealthHandler(w, r)
}
