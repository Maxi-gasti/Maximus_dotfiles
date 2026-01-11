#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
CSS_FILE="$WAYBAR_DIR/style.css"
TEMA1="$WAYBAR_DIR/themes/theme1.css"
TEMA2="$WAYBAR_DIR/themes/theme2.css"
TEMA3="$WAYBAR_DIR/themes/theme3.css"

CONFIG_FILE="$WAYBAR_DIR/config.jsonc"
CONFIG_FILE1="$WAYBAR_DIR/configs/config1.jsonc"
CONFIG_FILE2="$WAYBAR_DIR/configs/config2.jsonc"

# Función para verificar a qué apunta el enlace actual
get_current_theme() {
    if [ -L "$CONFIG_FILE" ]; then
        current_config_target=$(readlink -f "$CONFIG_FILE")
        if [ "$current_config_target" = "$CONFIG_FILE1"] || [ "$current_config_target" = "$CONFIG_FILE2"]; then
        echo "nada"
        else
          ln -sf "$CONFIG_FILE1" "$CONFIG_FILE"
        fi
    fi
    if [ -L "$CSS_FILE" ]; then
        current_target=$(readlink -f "$CSS_FILE")
        if [ "$current_target" = "$TEMA1" ]; then
            echo "tema1"
        elif [ "$current_target" = "$TEMA2" ]; then
            echo "tema2"
        elif [ "$current_target" = "$TEMA3" ]; then
            echo "tema3"
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
            ;;
        "tema2")
            ln -sf "$TEMA3" "$CSS_FILE"
            ;;
        "tema3")
            ln -sf "$TEMA1" "$CSS_FILE"
            ;;
        "not_linked"|"unknown")
            ln -sf "$TEMA1" "$CSS_FILE"
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
