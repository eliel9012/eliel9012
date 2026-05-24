#!/usr/bin/env bash
# Cria uma pasta de sessão com nome baseado em data/hora e tipo de teste.
# Uso: ./scripts/criar_sessao.sh <tipo-do-teste>
# Exemplo: ./scripts/criar_sessao.sh fax-enviar

set -euo pipefail

SESSOES_DIR="$(cd "$(dirname "$0")/.." && pwd)/sessions"

if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <tipo-do-teste>"
    echo "Exemplo: $0 fax-enviar"
    exit 1
fi

TIPO="$1"
TIMESTAMP="$(date '+%Y-%m-%d_%H%M%S')"
NOME="${TIMESTAMP}_${TIPO}"
DESTINO="${SESSOES_DIR}/${NOME}"

mkdir -p "$DESTINO"

cat > "${DESTINO}/resumo.md" <<EOF
# Sessão

Data: $(date '+%Y-%m-%d %H:%M:%S')
Tipo de teste: ${TIPO}
Menu usado no Mega Net:
Número configurado no Asterisk:
Número capturado pelo Asterisk (EXTEN):
Código do cartucho usado? não publicar valor — registrar apenas "sim" ou "não"
HT812 porta usada: PHONE 1
Codec:
Echo cancellation:
Fax mode:
Resultado:
FAXSTATUS:
FAXERROR:
FAXPAGES:
FAXBITRATE:
Arquivo TIF gerado:
Observações:
EOF

echo "Sessão criada: ${DESTINO}"
echo "Preencha ${DESTINO}/resumo.md após o experimento."
