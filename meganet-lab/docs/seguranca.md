# Segurança no laboratório

Este documento descreve os riscos e as práticas obrigatórias para trabalhar com o Mega Net Lab.

---

## Isolamento elétrico

### Não ligue o RJ11 diretamente ao GPIO do Raspberry Pi

O conector RJ11 de uma linha analógica opera com tensão de bateria de **48 V DC em repouso** e picos de **90 V AC durante o toque**. O GPIO do Raspberry Pi opera em **3,3 V**. Ligar diretamente causa dano permanente ao Pi e risco de choque.

Use o Grandstream HT812 como intermediário. A porta FXS do HT812 fornece a tensão de linha correta para o Mega Net e converte o sinal para SIP/RTP, que o Asterisk processa com segurança.

### Não ligue o FXS à rede telefônica pública

A porta FXS do HT812 **fornece** tensão de linha; a rede pública (PSTN) também **fornece** tensão de linha. Conectar FXS a FXO da rede pública pode danificar o HT812 e expor o experimento a requisitos legais de homologação.

O laboratório deve ser completamente isolado da rede pública. Use apenas a rede IP local (LAN privada).

### Não use a entrada de microfone do computador sem isolamento

Se a captura de áudio for feita diretamente pela entrada analógica de um computador, use um **transformador de áudio isolado** (balun) entre o circuito do cartucho e a interface de som. Sem isolamento, há risco de dano à placa de som e de injeção de ruído.

---

## Medição antes de conectar

Antes de ligar o Mega Net ao adaptador pela primeira vez:

1. Com o HT812 ligado e registrado no Asterisk, meça a tensão entre os fios do RJ11 com um multímetro em DC.
   - Deve medir entre 40 V e 52 V DC (polaridade pode variar).
2. Confirme continuidade mecânica do adaptador Telebras/Aplam → RJ11 sem nenhum dispositivo conectado.
3. Só então conecte o Mega Net.

---

## Teste com telefone analógico comum antes do Mega Net

Antes de usar o cartucho:

1. Conecte um telefone analógico comum à porta FXS do HT812.
2. Verifique se há tom de discagem.
3. Disque o ramal configurado no Asterisk.
4. Confirme que a chamada aparece nos logs.
5. Confirme que o WAV é gravado corretamente.

Só avance para o Mega Net depois que a bancada estiver validada.

---

## Código de acesso do cartucho

O cartucho Mega Net pode ter um código de acesso na etiqueta. Esse código é dado privado e potencialmente sensível do ponto de vista histórico.

- Não fotografe o código e publique a imagem.
- Não mencione o código em issues, commits ou comentários.
- Não inclua o código em logs ou PCAPs publicados.
- Guarde o código em documento local privado, fora do repositório.
- Use valores fictícios (ex.: `XXXX-YYYY`) em qualquer exemplo ou documentação.

---

## Revisão antes de publicar qualquer arquivo

Antes de publicar WAV, PCAP, LOG ou TIF:

- Verifique se o log contém o código do cartucho.
- Verifique se o PCAP contém a senha do SIP ou outros dados privados.
- Verifique se o WAV contém fala ou dados que não devem ser públicos.
- Anonymize o que for necessário.

---

## Resumo das regras

| Ação | Permitido |
|---|---|
| Conectar Mega Net ao HT812 FXS | ✅ Sim, com medição prévia |
| Conectar HT812 à rede IP local | ✅ Sim |
| Conectar HT812 à rede pública PSTN | ❌ Não |
| Ligar RJ11 ao GPIO do Raspberry Pi | ❌ Não |
| Publicar código da etiqueta do cartucho | ❌ Não |
| Publicar logs sem revisão | ❌ Não |
| Testar com telefone analógico antes | ✅ Obrigatório |
