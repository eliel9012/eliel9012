# Fax no Mega Net Lab

Este documento explica como o fax funciona no contexto do laboratório, por que o arquivo resultante é `.tif`, e as limitações do fax sobre VoIP.

---

## Por que fax gera arquivo `.tif`?

O formato TIFF (Tagged Image File Format) é o padrão histórico para fax digital desde os anos 1980. O fax analógico G3 transmite páginas como imagens bitmap monocromáticas comprimidas com algoritmo MH (Modified Huffman), MR (Modified Read) ou MMR (Modified Modified Read). O TIFF suporta esses codecs nativamente.

O Asterisk, via módulo `res_fax` e biblioteca SpanDSP, armazena o fax recebido como TIFF multi-página. Cada página do fax vira uma imagem dentro do mesmo arquivo `.tif`.

---

## Fluxo de envio pelo Mega Net

Hipótese: o Mega Net possuía funcionalidade de envio de mensagens ou dados que usava fax como protocolo de transporte.

Fluxo esperado:

```
1. Usuário seleciona opção de envio no menu do Mega Net.
2. Mega Net disca o número configurado (011-835 42 44 ou similar).
3. HT812 estabelece chamada SIP com o Asterisk.
4. Asterisk usa ReceiveFAX() para aguardar sinal de fax.
5. Mega Net inicia handshake de fax (tom CNG — 1100 Hz).
6. Asterisk responde com tom CED (2100 Hz) e inicia negociação T.30.
7. Fax é recebido e salvo em fax-recebido.tif.
```

Variáveis a investigar:
- O Mega Net realmente envia fax ou usa outro protocolo (FSK, DTMF, modem V.22)?
- Qual velocidade de modem? (V.21 300bps, V.22 1200bps, V.29 9600bps?)

---

## Fluxo de recepção pelo Mega Net

Hipótese: o Mega Net podia receber conteúdo (notícias, e-mail) via fax ou protocolo compatível.

Fluxo de teste:

```
1. Preparar arquivo TIF de teste (conteúdo simples).
2. No Asterisk, usar SendFAX() com o arquivo de teste.
3. Colocar o Mega Net em modo de recepção (se disponível no menu).
4. HT812 liga para o Mega Net (ou o Mega Net liga para o Asterisk).
5. Capturar WAV, PCAP e log durante a transmissão.
6. Observar o comportamento do Mega Net ao receber o sinal.
```

---

## Limitações do fax sobre VoIP

### Jitter e perda de pacotes

O fax analógico G3 foi projetado para PSTN, onde o timing é estrito e determinístico. Sobre VoIP, o jitter (variação no atraso dos pacotes) pode corromper a sincronização do modem de fax.

Em LAN local com Asterisk e HT812 na mesma rede, o jitter tende a ser baixo o suficiente para G.711 passthrough funcionar.

### G.711 passthrough vs T.38

- **G.711 passthrough:** o áudio do modem de fax trafega como áudio PCM normal. Funciona se o jitter for baixo. Mais simples de configurar.
- **T.38:** protocolo dedicado a fax sobre IP, com redundância de pacotes. Mais robusto, mas requer suporte explícito no HT812 e no módulo `res_fax`.

Para o laboratório, testar G.711 primeiro. Se falhar, habilitar T.38.

### Configuração recomendada no HT812

Na interface web do HT812:
- **Fax Mode:** T.38 ou Pass-Through
- **Re-INVITE After Fax Tone Detected:** Yes
- **Jitter Buffer:** Adaptive, Low
- **Echo Cancellation:** Off (para fax)

### Quando usar modem real

Se o protocolo do Mega Net não for fax G3 padrão — por exemplo, se usar FSK V.23 ou protocolo proprietário — o fax sobre VoIP não funcionará. Nesse caso, será necessário usar um modem analógico real conectado via simulador de linha (Camada 3 da arquitetura).

---

## Diagnóstico de falha de fax

Se `ReceiveFAX()` retornar `FAXSTATUS=FAILED`:

1. Verificar `FAXERROR` no log — identifica o ponto de falha na negociação T.30.
2. Verificar o espectrograma do WAV — o tom CNG (1100 Hz) deve aparecer no início.
3. Verificar se o codec é G.711 (ulaw/alaw) — G.722 e Opus são incompatíveis com fax passthrough.
4. Desligar echo cancellation no HT812 e no Asterisk.
5. Tentar com T.38 se G.711 falhar.
6. Analisar o PCAP no Wireshark: verificar se há mensagens T.38 ou se a chamada usa apenas RTP.

---

## Ferramentas de análise de fax

| Ferramenta | Uso |
|---|---|
| `tiffinfo arquivo.tif` | Metadados do arquivo fax recebido |
| `tiff2pdf arquivo.tif saida.pdf` | Converter TIF para PDF legível |
| `fax2tiff` | Decodificar fax de arquivo de áudio raw |
| `efax` | Software de fax para Linux, útil na Camada 3 |
| Wireshark + filtro T.38 | Analisar fax sobre IP no PCAP |
