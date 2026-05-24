# Arquitetura do laboratório

Este documento descreve as camadas técnicas da bancada do Mega Net Lab e as escolhas de projeto.

---

## Visão geral

O laboratório opera em três camadas progressivas. Cada camada adiciona complexidade e capacidade de análise. A Camada 1 é obrigatória; as demais são opcionais e dependem dos resultados da anterior.

---

## Camada 1 — HT812 + Asterisk (Observação segura)

```
Mega Drive + Cartucho Mega Net
        ↓ conector Telebras/Aplam
Adaptador Telebras/Aplam fêmea → RJ11 fêmea
        ↓ cabo RJ11 macho-macho
Grandstream HT812 — porta PHONE 1 (FXS)
        ↓ Ethernet (LAN privada)
Raspberry Pi 2 rodando Asterisk 18+
        ↓
Arquivos de sessão:
  audio.wav       (MixMonitor)
  meganet.pcap    (tcpdump)
  asterisk-full.log
```

### Por que o Grandstream HT812?

- Fornece tensão de linha analógica (~48 V DC) necessária para o Mega Net.
- Converte o sinal analógico para SIP/RTP, mantendo isolamento galvânico.
- Suporta T.38 para fax nativo e G.711 passthrough.
- Permite configuração de codec, DTMF mode, echo cancellation via interface web.
- É amplamente documentado e acessível.

### Por que o Asterisk?

- Software livre com suporte a `MixMonitor()`, `ReceiveFAX()`, `SendFAX()`.
- Logs detalhados com timestamps de milissegundos.
- Dialplan programável: permite rotear qualquer número discado para o contexto desejado.
- Roda bem no Raspberry Pi 2 (ARMv7, 1 GB RAM).

### Configuração de rede sugerida

| Dispositivo | IP |
|---|---|
| Raspberry Pi 2 | 10.10.10.1 |
| Grandstream HT812 | 10.10.10.2 |

Usar uma rede privada dedicada (switch ou cabo direto crossover) sem acesso à internet durante os experimentos.

---

## Camada 2 — Fax com ReceiveFAX / SendFAX

```
Mega Net → HT812 → Asterisk ReceiveFAX() → fax-recebido.tif

Asterisk SendFAX(arquivo.tif) → HT812 → Mega Net
```

### Requisitos adicionais

- Módulo `res_fax` ativo no Asterisk (verificar com `module show like fax`).
- SpanDSP instalado (`apt install -y libspandsp-dev`) para backend de fax.
- Codec G.711 (ulaw/alaw) ou T.38 habilitado no HT812.

### Limitações conhecidas de fax sobre VoIP

- Fax analógico (G3) é sensível a jitter e perda de pacotes.
- G.711 passthrough funciona em redes LAN locais com baixo jitter.
- T.38 é o padrão recomendado para fax sobre IP, mas exige suporte do HT812 e do módulo `res_fax`.
- Se o Mega Net usar velocidade de modem diferente de V.21/V.29/V.27ter, o fax pode não negociar.

Detalhes em [`docs/fax.md`](fax.md).

---

## Camada 3 — Simulador de linha + modem real (planejado)

```
Mega Net
  ↓ Telebras/Aplam → RJ11
Simulador de linha analógica
  ↓
Modem USB ou modem serial
  ↓
Software de modem (minimodem, wvdial, efax)
  ↓
Análise de protocolo bruto
```

### Quando usar esta camada

- O protocolo do Mega Net não é compatível com VoIP (ex.: modulação específica, timing rígido).
- A negociação de fax falha em todas as configurações da Camada 2.
- É necessário injetar respostas específicas ao cartucho (emulação de servidor).

### Componentes planejados

- Simulador de linha: fornece tom de discagem e tensão de bateria sem PSTN.
- Modem USB: dispositivo serial com suporte a Hayes AT commands.
- minimodem ou efax: software de modem para Linux.

---

## Diagrama completo

```
┌─────────────────────────────┐
│   Sega Mega Drive / Genesis  │
│   Cartucho Mega Net (TecToy) │
└──────────┬──────────────────┘
           │ Conector Telebras/Aplam macho
           ▼
┌─────────────────────────────┐
│  Adaptador Telebras/Aplam   │
│  fêmea → RJ11 fêmea         │
└──────────┬──────────────────┘
           │ Cabo RJ11 macho-macho
           ▼
┌─────────────────────────────┐
│  Grandstream HT812           │
│  Porta PHONE 1 (FXS)        │◄─ 48V DC linha analógica
└──────────┬──────────────────┘
           │ Ethernet (LAN privada 10.10.10.0/24)
           ▼
┌─────────────────────────────┐
│  Raspberry Pi 2              │
│  Asterisk 18+                │
│  tcpdump / tshark            │
└──────────┬──────────────────┘
           │
    ┌──────┴────────────────────────┐
    │                               │
    ▼                               ▼
audio.wav                    meganet.pcap
asterisk-full.log            fax-recebido.tif
spectrogram.png              dtmf.txt
eventos-importantes.txt      minimodem-*.txt
```
