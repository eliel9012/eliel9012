# Configuração do Asterisk

Este diretório contém exemplos de configuração do Asterisk para o Mega Net Lab.

---

## Arquivos de exemplo

| Arquivo | Destino em produção |
|---|---|
| `pjsip.conf.example` | `/etc/asterisk/pjsip.conf` |
| `extensions.conf.example` | `/etc/asterisk/extensions.conf` |
| `logger.conf.example` | `/etc/asterisk/logger.conf` |

---

## Como aplicar

```bash
sudo cp asterisk/pjsip.conf.example      /etc/asterisk/pjsip.conf
sudo cp asterisk/extensions.conf.example /etc/asterisk/extensions.conf
sudo cp asterisk/logger.conf.example     /etc/asterisk/logger.conf
```

Edite cada arquivo antes de usar:

- Em `pjsip.conf`: troque `troque-esta-senha` por uma senha forte.
- Em `extensions.conf`: ajuste o caminho `/opt/meganet-lab/sessions/` se necessário.
- Em `logger.conf`: ajuste o diretório de logs se necessário.

Após editar:

```bash
sudo asterisk -rx "core reload"
sudo asterisk -rx "pjsip reload"
sudo asterisk -rx "dialplan reload"
```

---

## Verificações pós-configuração

```bash
sudo asterisk -rvvvvv
```

No console interativo:

```
pjsip show endpoints
pjsip show aors
pjsip show auths
```

O endpoint `ht812` deve aparecer com status `Not in use` quando o HT812 estiver registrado.

---

## Segurança

- Nunca use a senha de exemplo `troque-esta-senha` em produção.
- Não exponha o Asterisk à internet. O laboratório deve operar em LAN privada.
- Não versione o `pjsip.conf` com senha real — use variáveis de ambiente ou cofre de segredos.
- Revise os logs do Asterisk antes de publicar qualquer sessão.
