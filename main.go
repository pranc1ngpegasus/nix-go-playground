package main

import (
	"net/http"
	"os"
)

func main() {
	logLevel := os.Getenv("LOG_LEVEL")
	logger := NewLogger(logLevel)

	mux := http.NewServeMux()
	mux.HandleFunc("GET /healthcheck", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	port := os.Getenv("PORT")
	handler := Chain(mux, Logging(logger))
	if err := http.ListenAndServe(":"+port, handler); err != nil {
		panic(err)
	}
}
