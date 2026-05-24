#!/usr/bin/env bash
# Processa todos os artefatos de uma sessão:
# espectrograma, DTMF, FSK e extração de eventos do log do Asterisk.
# Uso: ./scripts/processar_sessao.sh <caminho-da-sessao>
# Exemplo: ./scripts/processar_sessao.sh sessions/2026-05-24_153000_fax-enviar

set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <caminho-da-sessao>"
    exit 1
fi

SESSAO="$1"

if [[ ! -d "$SESSAO" ]]; then
    echo "Erro: diretório não encontrado: ${SESSAO}"
    exit 1
fi

WAV="${SESSAO}/audio.wav"
LOG="${SESSAO}/asterisk-full.log"

echo "=== Processando sessão: ${SESSAO} ==="

# Informações básicas do WAV
if [[ -f "$WAV" ]]; then
    echo ""
    echo "--- Informações do áudio ---"
    soxi "$WAV" || echo "soxi falhou (sox instalado?)"

    echo ""
    echo "--- Gerando espectrograma ---"
    bash "${SCRIPTS_DIR}/gerar_espectrograma.sh" "$WAV" "${SESSAO}/spectrogram.png"

    echo ""
    echo "--- Decodificando DTMF ---"
    bash "${SCRIPTS_DIR}/tentar_dtmf.sh" "$WAV" "${SESSAO}/dtmf.txt"

    echo ""
    echo "--- Decodificando FSK (minimodem) ---"
    bash "${SCRIPTS_DIR}/tentar_minimodem.sh" "$WAV" "$SESSAO"
else
    echo "Aviso: arquivo audio.wav não encontrado em ${SESSAO}"
fi

# Extração de eventos do log do Asterisk
if [[ -f "$LOG" ]]; then
    echo ""
    echo "--- Extraindo eventos do log do Asterisk ---"
    bash "${SCRIPTS_DIR}/extrair_eventos_asterisk.sh" "$LOG" "${SESSAO}/eventos-importantes.txt"
else
    echo "Aviso: arquivo asterisk-full.log não encontrado em ${SESSAO}"
fi

echo ""
echo "=== Processamento concluído ==="
echo "Preencha ${SESSAO}/resumo.md com os resultados."
