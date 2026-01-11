#!/bin/bash
base_dir="$HOME/.config/eww/"
state_file="${base_dir}music-state.json"

# Función para formatear tiempo
format_time() {
    local seconds=$1
    printf "%d:%02d" $((seconds / 60)) $((seconds % 60))
}

playerctl -F metadata -f '{{playerName}}|{{title}}|{{position}}|{{mpris:length}}' | while IFS='|' read -r player title position length; do
    # Solo procesar si tenemos datos válidos
    if [[ -n "$position" && -n "$length" ]]; then
        pos_sec=$(( (position + 500000) / 1000000 ))
        len_sec=$(( (length + 500000) / 1000000 ))
        
        # Verificar si es una nueva canción
        if [[ -f "$state_file" ]]; then
            last_title=$(jq -r '.title' "$state_file" 2>/dev/null)
            if [[ "$title" != "$last_title" ]]; then
                pos_sec=0  # Resetear posición para nueva canción
            fi
        fi
        
        # Actualizar estado
        jq -n -c \
            --arg title "$title" \
            --arg position "$pos_sec" \
            --arg positionStr "$(format_time $pos_sec)" \
            --arg length "$len_sec" \
            '{title: $title, position: $position, positionStr: $positionStr, length: $length}' > "$state_file"
            
        # Enviar datos actualizados
        cat "$state_file"
    fi
done
