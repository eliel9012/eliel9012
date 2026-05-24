# Hardware

Este diretório documenta os componentes físicos usados no Mega Net Lab.

---

## Componentes obrigatórios

### Sega Mega Drive ou Sega Genesis

O console original da Sega, lançado em 1988. O cartucho Mega Net foi produzido pela TecToy para o mercado brasileiro.

- Qualquer revisão do Mega Drive ou Mega Genesis é compatível com o cartucho.
- O console não precisa de modificação para este laboratório.

### Cartucho Mega Net (TecToy)

O cartucho principal do projeto. Contém um modem de baixa velocidade integrado e um conector telefônico Telebras/Aplam na parte traseira.

- Guardar o código de acesso da etiqueta em local privado.
- Não publicar o código.
- Inspecionar o conector antes de usar.

### Grandstream HT812

Adaptador de telefone analógico (ATA) com duas portas FXS.

- Porta PHONE 1: conectada ao Mega Net via adaptador e cabo RJ11.
- Porta PHONE 2: disponível para testes com telefone analógico comum.
- Firmware: manter atualizado para compatibilidade com T.38.

### Raspberry Pi 2 Model B

Computador de placa única com ARMv7 (Cortex-A7), 1 GB de RAM.

- Sistema: Raspberry Pi OS Lite (sem interface gráfica).
- Software: Asterisk 18+, tcpdump, sox, multimon-ng, minimodem.
- Armazenamento: cartão microSD ≥ 8 GB (recomendado 16 GB ou mais para sessões).

### Adaptador Telebras/Aplam fêmea → RJ11 fêmea

Necessário para conectar o cabo do Mega Net ao HT812.

- O conector Telebras/Aplam tem pinagem diferente do RJ11.
- Verificar continuidade e polaridade antes de usar.
- Detalhes em [`hardware/pinagem/README.md`](pinagem/README.md).

---

## Componentes opcionais

### Telefone analógico comum

Usado para validar a bancada antes de conectar o Mega Net. Qualquer telefone com conector RJ11 funciona.

### Multímetro

Essencial para medir tensão de linha e verificar continuidade do adaptador.

### Modem USB

Para a Camada 3 da arquitetura (análise de protocolo sem VoIP).

### Simulador de linha analógica

Fornece tensão de bateria e tom de discagem sem precisar de PSTN. Útil para isolar o experimento completamente.

### Interface de áudio isolada

Para captura de sinal analógico com isolamento galvânico. Protege o computador e evita loops de terra.

---

## Fotos

Fotos da bancada e dos componentes são armazenadas em [`hardware/fotos/`](fotos/).

As fotos não são versionadas por padrão (ver `.gitignore`). Se quiser incluir fotos no repositório, adicione explicitamente com `git add -f`.

**Antes de publicar qualquer foto:**
- Verificar se o código de acesso do cartucho está visível.
- Verificar se há senhas ou dados privados na imagem.
- Cobrir ou borrar informações sensíveis antes de publicar.
