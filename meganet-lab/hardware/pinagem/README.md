# Pinagem — Conector Telebras/Aplam

Este documento descreve a pinagem do conector telefônico Telebras/Aplam usado no cartucho Mega Net e como adaptá-lo ao padrão RJ11.

---

## Contexto histórico

O padrão de conector telefônico doméstico no Brasil antes da adoção do RJ11 era definido pelo sistema Telebras (Telecomunicações Brasileiras S.A.). O conector, também chamado de Aplam (nome do fabricante), tem aparência diferente do RJ11 americano, embora ambos usem os mesmos 2 fios elétricos para a linha telefônica (Tip e Ring).

---

## Conector Telebras/Aplam — características físicas

- Forma quadrada ou retangular, com trava lateral.
- Fabricado em plástico, com pinos metálicos expostos.
- Comum em instalações telefônicas brasileiras dos anos 1980 e 1990.
- O cartucho Mega Net possui o conector **macho** (plugue).

---

## Pinagem elétrica

A linha telefônica analógica usa apenas 2 fios para voz:

| Sinal | Descrição |
|---|---|
| Tip (T) | Fio positivo da linha (normalmente verde ou vermelho) |
| Ring (R) | Fio negativo da linha (normalmente preto ou amarelo) |

O conector Telebras/Aplam pode ter 4 pinos físicos, mas apenas 2 são usados para a linha principal.

**Atenção:** a designação de cores pode variar conforme o fabricante e a época do produto. Sempre medir com multímetro antes de conectar.

---

## Adaptador Telebras/Aplam → RJ11

Para conectar o Mega Net ao Grandstream HT812 (que usa RJ11):

```
Telebras/Aplam macho (Mega Net)
  → Adaptador Telebras/Aplam fêmea → RJ11 fêmea
    → Cabo RJ11 macho-macho
      → HT812 porta PHONE (RJ11)
```

### Como verificar o adaptador

1. Com o adaptador desconectado de qualquer dispositivo:
2. Medir resistência entre o pino Tip do lado Telebras e o pino Tip do lado RJ11.
   - Deve ser próximo de 0 Ω (continuidade).
3. Medir resistência entre o pino Ring do lado Telebras e o pino Ring do lado RJ11.
   - Deve ser próximo de 0 Ω.
4. Verificar que não há continuidade entre Tip e Ring (sem curto-circuito).

---

## Pinagem RJ11

O conector RJ11 tem 6 posições, mas a linha telefônica usa as 2 centrais:

```
Posição: 1  2  3  4  5  6
              ↑  ↑
           Ring Tip   (posições 3 e 4 — par central)
```

O Grandstream HT812 espera a linha nos pinos centrais (posições 3 e 4) do RJ11.

---

## Notas de medição

*(Preencher após medição real do adaptador e do cartucho)*

- Data da medição: ______
- Tensão no RJ11 livre (HT812 ligado): ______ V DC
- Continuidade Tip→Tip: ☐ OK ☐ Falha
- Continuidade Ring→Ring: ☐ OK ☐ Falha
- Curto Tip-Ring: ☐ Não detectado ☐ Detectado (problema!)
- Observações: ______
