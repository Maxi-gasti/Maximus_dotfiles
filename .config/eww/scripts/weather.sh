#!/bin/bash
CITY="Parana,Argentina"  # Ej: "Madrid", "Buenos_Aires", "New York"
FORMAT="%t+%C"    # Formato: temperatura + condición

# Obtener datos del clima
WEATHER=$(curl -s "wttr.in/$CITY?format=$FORMAT" 2>/dev/null)

# Si hay error, mostrar mensaje
if [ -z "$WEATHER" ] || [ "$WEATHER" = "Unknown location" ]; then
    echo "⏳ Error clima"
else
    echo "$WEATHER"
fi
