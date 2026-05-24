#!/usr/bin/env bash
# Gera espectrograma PNG a partir de arquivo WAV usando SoX.
# Uso: ./scripts/gerar_espectrograma.sh <audio.wav> [saida.png]
# Exemplo: ./scripts/gerar_espectrograma.sh sessions/2026-05-24_001/audio.wav

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <audio.wav> [saida.png]"
    exit 1
fi

WAV="$1"
PNG="${2:-${WAV%.wav}_spectrogram.png}"

if [[ ! -f "$WAV" ]]; then
    echo "Erro: arquivo não encontrado: ${WAV}"
    exit 1
fi

sox "$WAV" -n spectrogram \
    -x 1600 \
    -y 600  \
    -z 120  \
    -o "$PNG"

echo "Espectrograma salvo em: ${PNG}"
