#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
CONFIG_FILE="$WAYBAR_DIR/config.jsonc"
CONFIG_ALT_FILE="$WAYBAR_DIR/configs/config_alt.jsonc"
CONFIG_ALT_FILE2="$WAYBAR_DIR/configs/config_alt2.jsonc"

CSS_FILE="$WAYBAR_DIR/style.css"
TEMA1="$WAYBAR_DIR/themes/alt/theme1.css"
TEMA2="$WAYBAR_DIR/themes/alt/theme2.css"

# Función para verificar a qué apunta el enlace actual
get_current_theme() {
    if [ -L "$CSS_FILE" ]; then
        current_target=$(readlink -f "$CSS_FILE")
        if [ "$current_target" = "$TEMA1" ]; then
            echo "tema1"
        elif [ "$current_target" = "$TEMA2" ]; then
            echo "tema2"
        else
            echo "unknown"
        fi
    else
        echo "not_linked"
    fi
}

# Función para alternar temas
toggle_theme() {
    current=$(get_current_theme)
    
    case $current in
        "tema1")
            ln -sf "$TEMA2" "$CSS_FILE"
            ln -sf "$CONFIG_ALT_FILE2" "$CONFIG_FILE"
            ;;
        "tema2")
            ln -sf "$TEMA1" "$CSS_FILE"
            ln -sf "$CONFIG_ALT_FILE" "$CONFIG_FILE"
            ;;
        "not_linked"|"unknown")
            ln -sf "$TEMA1" "$CSS_FILE"
            ln -sf "$CONFIG_ALT_FILE" "$CONFIG_FILE"
            ;;
    esac
    
    
    restart_waybar
}

# Función para reiniciar waybar
restart_waybar() {
    pkill waybar || true
    waybar &
}

toggle_theme
