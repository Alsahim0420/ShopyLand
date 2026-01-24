#!/bin/bash

# Script para verificar que la cobertura sea mayor al 80%

echo "🔍 Verificando cobertura de tests..."

# Ejecutar tests con cobertura
flutter test --coverage

if [ ! -f coverage/lcov.info ]; then
    echo "❌ No se encontró el archivo de cobertura"
    exit 1
fi

# Extraer el porcentaje de cobertura usando lcov
COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep -oP '\d+\.\d+%' | head -1 | sed 's/%//')

if [ -z "$COVERAGE" ]; then
    echo "⚠️  No se pudo extraer el porcentaje de cobertura"
    echo "📊 Mostrando resumen completo:"
    lcov --summary coverage/lcov.info
    exit 0
fi

echo "📊 Cobertura actual: ${COVERAGE}%"
echo "🎯 Cobertura requerida: 80%"

# Comparar cobertura (usando bc para comparación de decimales)
if (( $(echo "$COVERAGE >= 80" | bc -l) )); then
    echo "✅ ¡Cobertura de tests es mayor al 80%!"
    exit 0
else
    echo "❌ Cobertura de tests es menor al 80%"
    echo "💡 Considera agregar más tests para aumentar la cobertura"
    exit 1
fi
