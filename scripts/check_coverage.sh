#!/bin/bash

# Script para verificar cobertura de tests (objetivo: >= 80%)

echo "🔍 Verificando cobertura de tests..."

# Ejecutar tests con cobertura
flutter test --coverage

if [ ! -f coverage/lcov.info ]; then
    echo "❌ No se encontró el archivo de cobertura"
    exit 1
fi

if [ ! -s coverage/lcov.info ]; then
    echo "❌ coverage/lcov.info está vacío (ejecuta tests que usen código de lib/)"
    exit 1
fi

echo ""
echo "📊 Resumen de cobertura:"
lcov --summary coverage/lcov.info 2>&1 || true

# Intentar extraer porcentaje (lcov summary formato puede variar)
COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep -oE '[0-9]+\.[0-9]+%' | head -1 | tr -d '%')

if [ -n "$COVERAGE" ]; then
    echo ""
    echo "📈 Cobertura de líneas: ${COVERAGE}% (objetivo: 80%)"
    if command -v bc &>/dev/null; then
        if (( $(echo "$COVERAGE >= 80" | bc -l 2>/dev/null || echo 0) )); then
            echo "✅ Cobertura >= 80%"
        else
            echo "⚠️  Cobertura < 80%. Añade más tests en test/unit/ y test/widget/."
        fi
    fi
fi

exit 0
