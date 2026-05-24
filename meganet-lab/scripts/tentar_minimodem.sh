#!/usr/bin/env bash
# Tenta decodificar sinal FSK de um arquivo WAV usando minimodem em múltiplas velocidades.
# Uso: ./scripts/tentar_minimodem.sh <audio.wav> [diretorio-saida]
# Exemplo: ./scripts/tentar_minimodem.sh sessions/2026-05-24_001/audio.wav sessions/2026-05-24_001

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <audio.wav> [diretorio-saida]"
    exit 1
fi

WAV="$1"
DIR_SAIDA="${2:-$(dirname "$WAV")}"

if [[ ! -f "$WAV" ]]; then
    echo "Erro: arquivo não encontrado: ${WAV}"
    exit 1
fi

if ! command -v minimodem &>/dev/null; then
    echo "Erro: minimodem não instalado. Execute: sudo apt install -y minimodem"
    exit 1
fi

for BAUD in 300 1200 2400; do
    SAIDA="${DIR_SAIDA}/minimodem-${BAUD}.txt"
    echo "Tentando decodificação FSK a ${BAUD} baud..."
    minimodem --rx "$BAUD" --file "$WAV" > "$SAIDA" 2>&1 || true

    BYTES="$(wc -c < "$SAIDA")"
    if [[ "$BYTES" -gt 0 ]]; then
        echo "  → Saída em ${SAIDA} (${BYTES} bytes)"
    else
        echo "  → Sem dados decodificados a ${BAUD} baud."
    fi
done

echo "Concluído. Verifique os arquivos minimodem-*.txt em ${DIR_SAIDA}/"
