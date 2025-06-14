package healthz

import (
	"net/http"
	"payroll-service/modules/healthz/internal/handlers"
)

// HealthHandler exposes the health check handler
func HealthHandler(w http.ResponseWriter, r *http.Request) {
	handlers.HealthHandler(w, r)
}
