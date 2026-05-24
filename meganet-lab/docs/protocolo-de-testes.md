# Protocolo de testes

Este documento descreve as fases dos experimentos no Mega Net Lab, do mais simples ao mais complexo. Cada fase deve ser concluída e documentada antes de avançar.

---

## Fase 0 — Bancada sem Mega Net

**Objetivo:** validar que toda a infraestrutura funciona antes de introduzir o cartucho.

Passos:

1. Instalar e configurar o Asterisk no Raspberry Pi 2.
2. Registrar o HT812 como endpoint SIP no Asterisk.
3. Confirmar registro com `pjsip show endpoints` no console do Asterisk.
4. Conectar telefone analógico comum à porta FXS do HT812.
5. Discar ramal de teste configurado no dialplan.
6. Confirmar chamada no console do Asterisk.
7. Confirmar que o WAV é gravado em `sessions/`.
8. Confirmar que o PCAP captura tráfego SIP e RTP.

Resultado esperado: chamada funciona, WAV gravado, PCAP com pacotes SIP/RTP.

---

## Fase 1 — Teste com telefone analógico

**Objetivo:** simular o comportamento que o Mega Net terá, usando um telefone comum como substituto controlado.

Passos:

1. Com a bancada validada na Fase 0:
2. Configurar no dialplan o número `011-835-4244` (ou equivalente local) como ramal de destino.
3. Discar esse número com o telefone analógico.
4. Confirmar que o Asterisk atende, grava e encerra corretamente.
5. Processar a sessão com `scripts/processar_sessao.sh`.
6. Revisar espectrograma e verificar que o áudio está limpo.

Resultado esperado: sessão completa com WAV e espectrograma sem artefatos.

---

## Fase 2 — Primeira discagem do Mega Net

**Objetivo:** capturar o número que o Mega Net disca ao inicializar.

Passos:

1. Conectar o Mega Net ao HT812 via adaptador e cabo RJ11.
2. Iniciar `tcpdump` antes de ligar o console.
3. Iniciar o console com o cartucho inserido.
4. Observar o log do Asterisk em tempo real.
5. Anotar o número que aparece nos logs (`EXTEN`).
6. Salvar a sessão com `scripts/criar_sessao.sh discagem-inicial`.

Perguntas a responder:

- O número discado é `011-835 42 44`?
- O cartucho disca imediatamente ou aguarda entrada do usuário?
- Há sinais DTMF adicionais após a discagem?

---

## Fase 3 — Teste de funcionalidades do menu

**Objetivo:** explorar as opções do menu do Mega Net (e-mail, notícias, revista eletrônica) e capturar o comportamento de cada uma.

Passos:

1. Para cada opção do menu, criar uma sessão separada.
2. Navegar até a opção desejada e confirmar.
3. Capturar o WAV, PCAP e log completos.
4. Processar com `scripts/processar_sessao.sh`.
5. Analisar o espectrograma e os resultados do minimodem.

Cada opção pode usar protocolo diferente (DTMF, FSK, fax). Registrar hipóteses e resultados separadamente.

---

## Fase 4 — Teste de fax — envio pelo Mega Net

**Objetivo:** determinar se o Mega Net envia fax e capturar o arquivo TIF resultante.

Passos:

1. Configurar o dialplan para usar `ReceiveFAX()` na rota do número discado.
2. Navegar no Mega Net até a opção que provavelmente envia fax.
3. Aguardar a negociação T.38 ou G.711 fax passthrough.
4. Verificar se o arquivo `fax-recebido.tif` foi criado.
5. Verificar `FAXSTATUS`, `FAXERROR`, `FAXPAGES` nos logs.
6. Analisar o TIF se gerado.

Resultado esperado: arquivo TIF com conteúdo (possivelmente texto ou dados codificados).

---

## Fase 5 — Teste de fax — recepção pelo Mega Net

**Objetivo:** determinar se o Mega Net consegue receber um fax enviado pelo Asterisk.

Passos:

1. Preparar um arquivo TIF de teste (página em branco ou texto simples).
2. Usar `SendFAX()` no Asterisk para enviar ao ramal do HT812.
3. Colocar o Mega Net em modo de recepção (se essa opção existir).
4. Capturar WAV e PCAP durante a transmissão.
5. Observar o comportamento do Mega Net ao receber o sinal de fax.

---

## Fase 6 — Análise de sinais

**Objetivo:** interpretar o áudio capturado para determinar o protocolo usado.

Ferramentas:

- `sox` — espectrograma visual
- `multimon-ng` — decodificação DTMF
- `minimodem` — decodificação FSK em múltiplas velocidades
- Wireshark — análise do PCAP (SIP, RTP, T.38)

Para cada sessão:

1. Inspecionar o espectrograma em busca de padrões reconhecíveis.
2. Identificar se há DTMF, FSK, V.21, V.22, V.23, V.34 ou outro.
3. Tentar decodificação com a ferramenta apropriada.
4. Documentar hipótese e resultado no `resumo.md` da sessão.

---

## Fase 7 — Modem real ou simulador de linha (planejado)

**Objetivo:** emular a PSTN com maior fidelidade para protocolos que não funcionam sobre VoIP.

Situações que podem exigir esta fase:

- O Mega Net usa protocolo incompatível com VoIP (ex.: V.34 assíncrono).
- A negociação de fax falha em G.711 e T.38.
- O cartucho requer tom de discagem com características específicas.

Abordagens possíveis:

- Simulador de linha analógica (ex.: Cleo SLA-1 ou similar).
- Modem USB com suporte a minimodem ou wvdial.
- Interface de áudio isolada com software de modem (fax2tiff, efax).

Esta fase será documentada em separado quando necessário.
