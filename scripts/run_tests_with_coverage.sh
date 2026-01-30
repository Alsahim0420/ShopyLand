#!/bin/bash

# Script para ejecutar tests y generar reporte de cobertura con lcov

echo "🧪 Ejecutando tests y generando reporte de cobertura..."

# Limpiar reportes anteriores (mantener carpeta coverage/ y .gitkeep)
rm -f coverage/lcov.info
rm -rf coverage/html

# Ejecutar tests con cobertura
flutter test --coverage || {
    echo "❌ flutter test --coverage falló. Ejecuta en tu terminal:"
    echo "   flutter test --coverage"
    echo "   ./scripts/gen_coverage_html.sh"
    exit 1
}

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
if [ ! -f coverage/lcov.info ]; then
    echo "❌ No se encontró coverage/lcov.info"
    exit 1
fi

if [ ! -s coverage/lcov.info ]; then
    echo "❌ coverage/lcov.info está vacío. Ejecuta tests que usen código de lib/ (p. ej. test/unit/)."
    exit 1
fi

echo "📊 Generando reporte HTML..."
genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage

echo ""
echo "📈 Resumen de cobertura:"
lcov --summary coverage/lcov.info

echo ""
echo "✅ Reporte HTML generado en: coverage/html/index.html"
echo "🌐 Abre: open coverage/html/index.html"
if [[ "$OSTYPE" == "darwin"* ]]; then
    open coverage/html/index.html
fi
