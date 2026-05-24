# Sessões

Este diretório armazena os resultados de cada experimento realizado no Mega Net Lab.

---

## Estrutura de uma sessão

Cada sessão é uma pasta nomeada no formato:

```
AAAA-MM-DD_HHMMSS_<tipo-do-teste>/
```

Exemplo:

```
2026-05-24_153000_fax-enviar/
  audio.wav              — áudio completo da chamada (MixMonitor)
  meganet.pcap           — captura de pacotes SIP/RTP (tcpdump)
  asterisk-full.log      — log completo do Asterisk durante a sessão
  fax-recebido.tif       — arquivo fax recebido (se aplicável)
  spectrogram.png        — espectrograma do áudio
  dtmf.txt               — resultado da decodificação DTMF
  minimodem-300.txt      — tentativa FSK a 300 baud
  minimodem-1200.txt     — tentativa FSK a 1200 baud
  minimodem-2400.txt     — tentativa FSK a 2400 baud
  eventos-importantes.txt — eventos filtrados do log do Asterisk
  resumo.md              — notas e resultado do experimento
```

---

## Como criar uma sessão

```bash
./scripts/criar_sessao.sh <tipo-do-teste>
```

Tipos sugeridos:

- `discagem-inicial`
- `fax-enviar`
- `fax-receber`
- `email`
- `noticias`
- `revista`
- `teste-telefone`

---

## Como processar uma sessão

Após copiar os arquivos para a pasta da sessão:

```bash
./scripts/processar_sessao.sh sessions/<nome-da-sessao>
```

---

## Privacidade e publicação

As pastas de sessão **não são versionadas por padrão** (ver `.gitignore`).

Antes de publicar qualquer arquivo de sessão:

- Revisar o log do Asterisk em busca do código de acesso do cartucho.
- Revisar o PCAP em busca de senhas ou dados privados.
- Revisar o WAV (dados de áudio podem conter informações sensíveis).
- Anonymize o que for necessário antes de publicar.
