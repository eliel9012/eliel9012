# Mega Net Lab

Laboratório de preservação e engenharia reversa do cartucho Mega Net da TecToy.

---

> ⚠️ **Aviso de segurança**
>
> Este projeto deve ser executado apenas em laboratório isolado.
> Não conecte o cartucho Mega Net, o Grandstream HT812 ou qualquer porta FXS à rede telefônica pública.
> Não ligue o RJ11 do Mega Net diretamente ao GPIO do Raspberry Pi, à entrada de áudio do computador ou a qualquer circuito sem isolamento apropriado.

---

## Objetivo

O objetivo deste projeto é documentar de forma reprodutível o comportamento do cartucho Mega Net da TecToy em ambiente de bancada controlado. Não há intenção de conectar o cartucho à rede telefônica pública, acessar sistemas de terceiros ou realizar qualquer atividade além da preservação e análise técnica.

Os experimentos visam capturar:

- o número discado pelo cartucho ao inicializar;
- logs completos do Asterisk durante cada sessão;
- áudio da chamada em formato WAV;
- tráfego SIP/RTP em formato PCAP;
- tentativa de envio e recepção de fax, com arquivos TIF;
- espectrogramas do sinal de áudio;
- resultados de decodificação DTMF e FSK.

---

## Arquitetura resumida

```
Mega Net
  ↓ Telebras/Aplam
Adaptador Telebras/Aplam → RJ11
  ↓ RJ11
Grandstream HT812, porta FXS
  ↓ Ethernet
Raspberry Pi 2 + Asterisk
  ↓
WAV + PCAP + LOG + TIF
```

Detalhes completos em [`docs/arquitetura.md`](docs/arquitetura.md).

---

## Número histórico do Mega Net

O manual do Mega Net indica como telefone de acesso:

`011-835 42 44`

Neste projeto, esse número é tratado como referência histórica e como alvo lógico em ambiente de laboratório isolado. Não se deve tentar discar esse número na rede telefônica pública.

---

## Código de acesso do cartucho

O cartucho Mega Net pode possuir uma etiqueta com um código de acesso da TecToy. Esse código provavelmente era usado no fluxo de cadastro/autenticação original.

- **Não publique esse código no repositório.**
- **Não coloque o código em screenshots públicas.**
- **Não envie esse código em issues.**
- Use valores fictícios nos exemplos.

---

## Hardware utilizado

| Componente | Função |
|---|---|
| Sega Mega Drive ou Sega Genesis | Console principal |
| Cartucho Mega Net (TecToy) | Dispositivo sob análise |
| Adaptador Telebras/Aplam fêmea → RJ11 fêmea | Conversão mecânica do conector |
| Cabo RJ11 macho-macho | Conexão HT812 ↔ adaptador |
| Grandstream HT812 | ATA com porta FXS; simula linha analógica |
| Raspberry Pi 2 com Raspberry Pi OS Lite | Servidor Asterisk |
| Cartão microSD (≥ 8 GB) | Sistema e armazenamento de sessões |
| Cabo Ethernet | Conexão HT812 ↔ Raspberry Pi |
| Telefone analógico comum | Validação da bancada antes do Mega Net |
| Multímetro | Verificação de tensão e continuidade |
| Modem USB (opcional) | Camada futura de análise de protocolo |
| Simulador de linha (opcional) | Isolamento galvânico e controle de nível |
| Interface de áudio isolada (opcional) | Captura de sinal sem risco ao hardware |

---

## Fluxos de teste

### Camada 1 — Observação segura

```
Mega Net → HT812 FXS → Asterisk → WAV + PCAP + logs
```

O Asterisk atende a chamada, grava o áudio com `MixMonitor()` e registra todos os eventos. O Mega Net faz o que faria naturalmente ao tentar conectar.

### Camada 2 — Teste de fax

**Envio pelo Mega Net:**

```
Mega Net → HT812 → Asterisk ReceiveFAX() → fax-recebido.tif
```

**Recepção pelo Mega Net:**

```
Asterisk SendFAX() → HT812 → Mega Net em modo RECEBER
```

### Camada 3 — Evolução futura

```
Mega Net → simulador de linha → modem real → análise de protocolo
```

Fase planejada para quando o protocolo original exigir emulação mais fiel da rede PSTN.

---

## Estrutura de sessões

Cada experimento é salvo em pasta própria, nomeada por data/hora e tipo de teste:

```
sessions/
  2026-05-24_001_fax-enviar/
    audio.wav
    meganet.pcap
    asterisk-full.log
    fax-recebido.tif
    spectrogram.png
    dtmf.txt
    minimodem-300.txt
    minimodem-1200.txt
    minimodem-2400.txt
    eventos-importantes.txt
    resumo.md
```

Os arquivos brutos (WAV, PCAP, LOG, TIF) não são versionados por padrão. Consulte `.gitignore`.

---

## Instalação das dependências

```bash
sudo apt update
sudo apt install -y asterisk tcpdump tshark sox alsa-utils multimon-ng minimodem
```

---

## Comandos principais

### Console interativo do Asterisk

```bash
sudo asterisk -rvvvvv
pjsip set logger on
core set verbose 5
core set debug 5
```

### Captura de tráfego SIP/RTP

```bash
sudo tcpdump -i eth0 -n -s 0 -w meganet.pcap 'host 10.10.10.2'
```

Substitua `10.10.10.2` pelo IP do Grandstream HT812.

### Geração de espectrograma

```bash
sox audio.wav -n spectrogram -x 1600 -y 600 -z 120 -o spectrogram.png
```

### Decodificação DTMF

```bash
multimon-ng -t wav -a DTMF audio.wav > dtmf.txt
```

### Decodificação FSK com minimodem

```bash
minimodem --rx 300  --file audio.wav > minimodem-300.txt
minimodem --rx 1200 --file audio.wav > minimodem-1200.txt
minimodem --rx 2400 --file audio.wav > minimodem-2400.txt
```

---

## Scripts

| Script | Uso |
|---|---|
| `scripts/criar_sessao.sh` | Cria pasta e template de sessão |
| `scripts/processar_sessao.sh` | Processa WAV, gera espectrograma, DTMF, FSK |
| `scripts/gerar_espectrograma.sh` | Gera PNG a partir de WAV |
| `scripts/tentar_dtmf.sh` | Decodifica DTMF de WAV |
| `scripts/tentar_minimodem.sh` | Decodifica FSK em 300/1200/2400 baud |
| `scripts/extrair_eventos_asterisk.sh` | Filtra eventos relevantes do log do Asterisk |

Exemplo de uso:

```bash
./scripts/criar_sessao.sh fax-enviar
./scripts/processar_sessao.sh sessions/2026-05-24_153000_fax-enviar
```

---

## Configuração do Asterisk

Exemplos de configuração estão em `asterisk/`:

- [`asterisk/pjsip.conf.example`](asterisk/pjsip.conf.example) — endpoint do HT812
- [`asterisk/extensions.conf.example`](asterisk/extensions.conf.example) — dialplan com gravação e fax
- [`asterisk/logger.conf.example`](asterisk/logger.conf.example) — logging completo

Copie os exemplos para `/etc/asterisk/` e ajuste antes de usar.

---

## Status do projeto

- [ ] Montar bancada física
- [ ] Testar HT812 com telefone analógico comum
- [ ] Configurar Asterisk no Raspberry Pi 2
- [ ] Capturar primeira discagem do Mega Net
- [ ] Confirmar se o número discado é 011-835 42 44
- [ ] Capturar primeiro WAV
- [ ] Capturar primeiro PCAP
- [ ] Testar envio de fax do Mega Net para `ReceiveFAX()`
- [ ] Testar recepção de fax no Mega Net via `SendFAX()`
- [ ] Avaliar necessidade de modem real ou simulador de linha

---

## Documentação

| Documento | Conteúdo |
|---|---|
| [`docs/seguranca.md`](docs/seguranca.md) | Riscos elétricos e práticas seguras |
| [`docs/protocolo-de-testes.md`](docs/protocolo-de-testes.md) | Fases e procedimentos de teste |
| [`docs/arquitetura.md`](docs/arquitetura.md) | Camadas da bancada e escolhas técnicas |
| [`docs/fax.md`](docs/fax.md) | Fax sobre VoIP, TIF, limitações |
| [`docs/checklist-bancada.md`](docs/checklist-bancada.md) | Lista de verificação antes de ligar o Mega Net |
| [`docs/manual/README.md`](docs/manual/README.md) | Referências ao manual original |
| [`docs/fontes/README.md`](docs/fontes/README.md) | Fontes de pesquisa e referências |
| [`hardware/README.md`](hardware/README.md) | Notas sobre os componentes físicos |
| [`hardware/pinagem/README.md`](hardware/pinagem/README.md) | Pinagem do conector Telebras/Aplam |

---

## Licença

Scripts e documentação originais deste repositório estão licenciados sob a [Licença MIT](LICENSE).

Este repositório não concede direitos sobre marcas, manuais, ROMs, firmware ou materiais proprietários da Sega, TecToy, Grandstream ou terceiros.
