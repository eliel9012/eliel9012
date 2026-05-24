# Capturas

Este diretório pode ser usado para armazenar capturas avulsas (PCAP, WAV) que não fazem parte de uma sessão estruturada.

---

## Atenção

Os arquivos neste diretório **não são versionados por padrão** (ver `.gitignore`).

Para capturas vinculadas a um experimento específico, use o diretório `sessions/` com `scripts/criar_sessao.sh`.

---

## Revisão antes de publicar

Antes de publicar qualquer captura:

- Verificar se o PCAP contém senhas SIP ou dados privados.
- Verificar se o WAV contém informações sensíveis.
- Não publicar capturas com o código de acesso do cartucho visível.
