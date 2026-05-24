#!/usr/bin/env bash
# Tenta decodificar tons DTMF de um arquivo WAV usando multimon-ng.
# Uso: ./scripts/tentar_dtmf.sh <audio.wav> [saida.txt]
# Exemplo: ./scripts/tentar_dtmf.sh sessions/2026-05-24_001/audio.wav

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <audio.wav> [saida.txt]"
    exit 1
fi

WAV="$1"
SAIDA="${2:-${WAV%.wav}_dtmf.txt}"

if [[ ! -f "$WAV" ]]; then
    echo "Erro: arquivo não encontrado: ${WAV}"
    exit 1
fi

if ! command -v multimon-ng &>/dev/null; then
    echo "Erro: multimon-ng não instalado. Execute: sudo apt install -y multimon-ng"
    exit 1
fi

echo "Decodificando DTMF de: ${WAV}"
multimon-ng -t wav -a DTMF "$WAV" > "$SAIDA" 2>&1

LINHAS="$(wc -l < "$SAIDA")"
echo "Resultado salvo em: ${SAIDA} (${LINHAS} linhas)"

if grep -q "DTMF:" "$SAIDA"; then
    echo "Tons DTMF detectados:"
    grep "DTMF:" "$SAIDA"
else
    echo "Nenhum tom DTMF detectado no arquivo."
fi
