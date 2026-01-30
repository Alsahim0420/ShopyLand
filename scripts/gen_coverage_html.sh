#!/bin/bash

# Genera solo el reporte HTML desde coverage/lcov.info.
# Usar cuando ya corriste: flutter test --coverage

set -e

if [ ! -f coverage/lcov.info ] || [ ! -s coverage/lcov.info ]; then
    echo "❌ No hay coverage/lcov.info o está vacío."
    echo "   Ejecuta antes: flutter test --coverage"
    exit 1
fi

if ! command -v lcov &>/dev/null; then
    echo "❌ lcov no está instalado. Ej.: brew install lcov"
    exit 1
fi

echo "📊 Generando reporte HTML..."
rm -rf coverage/html
genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage

echo ""
lcov --summary coverage/lcov.info
echo ""
echo "✅ coverage/html/index.html generado."
echo "   Abre: open coverage/html/index.html"
if [[ "$OSTYPE" == "darwin"* ]]; then
    open coverage/html/index.html 2>/dev/null || true
fi
