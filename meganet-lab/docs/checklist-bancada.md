# Checklist de bancada

Use esta lista antes de cada sessão com o Mega Net. Execute na ordem indicada.

---

## Infraestrutura

- [ ] Raspberry Pi 2 ligado e acessível via SSH
- [ ] Sistema operacional Raspberry Pi OS Lite funcional
- [ ] Asterisk instalado e iniciado (`systemctl status asterisk`)
- [ ] HT812 ligado, com IP fixo (`ping 10.10.10.2`)
- [ ] HT812 registrado no Asterisk (`pjsip show endpoints` mostra `ht812 | Not in use`)
- [ ] tcpdump disponível no Raspberry Pi (`which tcpdump`)
- [ ] Pasta de sessões acessível (`ls sessions/`)

## Validação da linha analógica

- [ ] Telefone analógico comum conectado à porta PHONE 1 do HT812
- [ ] Tom de discagem audível no telefone
- [ ] Discagem de ramal de teste bem-sucedida (Asterisk atende)
- [ ] WAV de teste gerado em `sessions/` com conteúdo de áudio
- [ ] PCAP de teste capturado com pacotes SIP e RTP
- [ ] Telefone analógico desconectado após validação

## Adaptador e cabeamento

- [ ] Adaptador Telebras/Aplam fêmea → RJ11 fêmea testado com multímetro (continuidade)
- [ ] Fios cruzados corretamente (verificar pinagem em `hardware/pinagem/README.md`)
- [ ] Cabo RJ11 macho-macho sem ruptura
- [ ] Tensão de linha medida no RJ11 livre: entre 40 V e 52 V DC (HT812 fornecendo)

## Mega Net

- [ ] Código do cartucho guardado em documento local privado (fora do repositório)
- [ ] Cartucho inserido no Mega Drive com o console desligado
- [ ] Cabo Telebras do Mega Net conectado ao adaptador
- [ ] Adaptador conectado ao HT812 PHONE 1 via cabo RJ11

## Captura

- [ ] Sessão criada com `./scripts/criar_sessao.sh <tipo>`
- [ ] tcpdump iniciado antes de ligar o Mega Drive
- [ ] Console do Asterisk aberto em outra sessão SSH (`sudo asterisk -rvvvvv`)

## Pós-sessão

- [ ] Mega Drive desligado
- [ ] tcpdump encerrado (Ctrl+C) e PCAP salvo
- [ ] Log do Asterisk copiado para a pasta da sessão
- [ ] Sessão processada com `./scripts/processar_sessao.sh <caminho>`
- [ ] `resumo.md` preenchido com os resultados
- [ ] Log e PCAP revisados antes de qualquer publicação
