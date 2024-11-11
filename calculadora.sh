#!/bin/bash

# Leitura dos dados do formulário
read -r input
num1=$(echo "$input" | sed -n 's/.*num1=\([^&]*\).*/\1/p' | sed 's/%20/ /g')
num2=$(echo "$input" | sed -n 's/.*num2=\([^&]*\).*/\1/p' | sed 's/%20/ /g')
operacao=$(echo "$input" | sed -n 's/.*operacao=\([^&]*\).*/\1/p')

# Decodificação dos números
num1=$(echo "$num1" | sed 's/+/ /g' | xargs)
num2=$(echo "$num2" | sed 's/+/ /g' | xargs)

# Operações matemáticas
resultado=""
case "$operacao" in
    "add")
        resultado=$(echo "$num1 + $num2" | bc)
        ;;
    "sub")
        resultado=$(echo "$num1 - $num2" | bc)
        ;;
    "mul")
        resultado=$(echo "$num1 * $num2" | bc)
        ;;
    "div")
        if [ "$num2" -ne 0 ]; then
            resultado=$(echo "scale=2; $num1 / $num2" | bc)
        else
            resultado="Erro: Divisão por zero"
        fi
        ;;
    *)
        resultado="Operação inválida"
        ;;
esac

# Resposta HTML
echo "Content-type: text/html"
echo ""
echo "<!DOCTYPE html>"
echo "<html lang='pt-BR'>"
echo "<head><meta charset='UTF-8'><title>Resultado</title></head>"
echo "<body>"
echo "<h1>Resultado</h1>"
echo "<p>O resultado da operação é: $resultado</p>"
echo "</body>"
echo "</html>"
