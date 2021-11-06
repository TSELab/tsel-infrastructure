# tsel-infrastructure

## Clone the repo

```sh
git clone https://github.com/TSELab/tsel-infrastructure.git
cd tsel-infrastructure/
```

## Setup the vault

Create a file with the vault secret at this location inside the repo:

```sh
cat > ansible/vault_key
redacted
^D
```

## Deploy a playbook

```sh
cd ansible/
# dry run
ansible-playbook playbooks/rebuilderd.yml -vv -DC
# deploy
ansible-playbook playbooks/rebuilderd.yml -vv -D
```
