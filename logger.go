package main

import (
	"log/slog"
	"os"
	"strings"
)

func NewLogger(logLevel string) *slog.Logger {
	return slog.New(
		slog.NewJSONHandler(
			os.Stdout,
			&slog.HandlerOptions{
				AddSource: true,
				Level: func(level string) slog.Leveler {
					switch strings.ToUpper(level) {
					case "DEBUG":
						return slog.LevelDebug.Level()
					case "INFO":
						return slog.LevelInfo.Level()
					case "WARN":
						return slog.LevelWarn.Level()
					case "ERROR":
						return slog.LevelError.Level()
					default:
						return slog.LevelInfo.Level()
					}
				}(logLevel),
			},
		),
	)
}
