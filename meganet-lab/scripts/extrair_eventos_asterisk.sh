#!/usr/bin/env bash
# Extrai eventos relevantes do log completo do Asterisk.
# Uso: ./scripts/extrair_eventos_asterisk.sh <asterisk-full.log> [saida.txt]
# Exemplo: ./scripts/extrair_eventos_asterisk.sh sessions/2026-05-24_001/asterisk-full.log

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <asterisk-full.log> [saida.txt]"
    exit 1
fi

LOG="$1"
SAIDA="${2:-${LOG%.*}_eventos-importantes.txt}"

if [[ ! -f "$LOG" ]]; then
    echo "Erro: arquivo não encontrado: ${LOG}"
    exit 1
fi

TERMOS=(
    "MEGANET"
    "FAX"
    "DTMF"
    "MixMonitor"
    "ReceiveFAX"
    "SendFAX"
    "Hangup"
    "INVITE"
    "PJSIP"
    "FAXSTATUS"
    "FAXERROR"
    "FAXPAGES"
)

PADRAO="$(IFS='|'; echo "${TERMOS[*]}")"

echo "Extraindo eventos de: ${LOG}"
echo "Padrões buscados: ${PADRAO}"

grep -E "$PADRAO" "$LOG" > "$SAIDA" 2>/dev/null || true

LINHAS="$(wc -l < "$SAIDA")"
echo "Eventos encontrados: ${LINHAS} linhas"
echo "Resultado salvo em: ${SAIDA}"
