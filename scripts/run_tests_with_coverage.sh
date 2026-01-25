#!/bin/bash

# Script para ejecutar tests y generar reporte de cobertura con lcov

echo "🧪 Ejecutando tests y generando reporte de cobertura..."

# Limpiar reportes anteriores
rm -rf coverage/
rm -f coverage/lcov.info

# Ejecutar tests con cobertura
flutter test --coverage

# Verificar si lcov está instalado
if ! command -v lcov &> /dev/null; then
    echo "⚠️  lcov no está instalado. Instalando..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install lcov
        else
            echo "❌ Por favor instala Homebrew y luego ejecuta: brew install lcov"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo apt-get update && sudo apt-get install -y lcov
    else
        echo "❌ Por favor instala lcov manualmente para tu sistema operativo"
        exit 1
    fi
fi

# Generar reporte HTML con lcov
if [ -f coverage/lcov.info ]; then
    echo "📊 Generando reporte HTML..."
    genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage
    
    # Calcular cobertura total
    echo ""
    echo "📈 Resumen de cobertura:"
    lcov --summary coverage/lcov.info
    
    echo ""
    echo "✅ Reporte HTML generado en: coverage/html/index.html"
    echo "🌐 Abre el reporte en tu navegador para ver los detalles"
else
    echo "❌ No se encontró el archivo coverage/lcov.info"
    exit 1
fi
