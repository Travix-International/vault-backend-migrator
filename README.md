## vault-backend-migrator

`vault-backend-migrator` is a tool to export and import (migrate) data across vault clusters.

Right now this tool really only supports the `secret`/`kv` (version 1) backend. Other mount points might work, but many create dynamic secrets behind the scenes or don't support all operations (i.e. LIST).

### Usage

##### Exporting

```
docker run -it \
-v (pwd)/bck:/bck \
-e VAULT_ADDR=<Vault-URL:Vault-Port> \
-e VAULT_CACERT=<full filepath to .crt bundle> \
-e VAULT_TOKEN=<Vault token> \
travix\vault-backend-migrator -export secret/ -file /bck/secrets.json
```

Note: You'll need to make sure the VAULT_TOKEN has permissions to list and read all vault paths.


This will create a file called `secrets.json` that has all the keys and paths. (Note: This is literally all the secrets from the generic backend. Don't share this file with anyone! The secret data is **encoded** in base64, but there's no protection over this file.)

##### Importing

Once you've created an export you are able to reconfigure the vault environment variables (`VAULT_ADDR` and `VAULT_TOKEN` usually) to run an import command.

```
docker run -it \
-v (pwd)/bck:/bck \
-e VAULT_ADDR=<Vault-URL:Vault-Port> \
-e VAULT_CACERT=<full filepath to .crt bundle> \
-e VAULT_TOKEN=<Vault token> \
vault-backend-migrator -import secret/ -file /bck/secrets.json
```

This will output each key the tool is writing to. After that a simple `vault list` command off the vault cli will show the secrets there.

Note: It's recommended that you now delete `secrets.json` if you don't need it. If you can install a tool like `srm` to really delete this file.


### Configuration

This tool reads all the `VAULT_*` environment variables as the vault cli does. You likely need to specify those for the address, CA certs, etc.

## Dependencies

I use [golang/dep](https://github.com/golang/dep) for managing the `vendor/` directory. I like to run `dep ensure && dep prune` to keep the tree small.