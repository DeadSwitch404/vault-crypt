# 🕶️ vault-crypt

> **DeadSwitch | The Cyber Ghost**  
> _"In silence, we rise. In the switch, we fade."_

Minimalist encryption for those who live off the grid.  
A GPG-powered vault manager for your `.kdbx` password databases.  
No GUI. No cloud. Just your keys, your vault, and the silence between.

---

## 🧭 What is `vault-crypt`?

A bash script that:
- Encrypts and signs your KeePassXC `.kdbx` file using GPG.
- Decrypts when needed, verifies signature integrity.
- Purges unsealed vaults to eliminate traces.
- Backs up your encrypted vault with timestamped versions.

All operations are local. No 3rd-party sync.  
You are the cloud. You are the guardian.

---

## 🔐 Philosophy

> *Your vault is your memory.  
> Sign it with your hand.  
> Seal it with your ghost.  
> Let no cloud eat what you protect.*  
> — DeadSwitch

---

## 🚀 Features

- ✅ GPG encryption + signature validation
- ✅ File wiping of plaintext vaults
- ✅ Timestamped backup creation
- ✅ Lightweight and auditable
- ✅ Config via `.env` file

---

## 📂 File Structure

```text
.
├── examples
│   └── sample.env
├── README.md
└── vault-crypt.sh
```

---

## ⚙️ Setup

### Clone the repo

```bash
git clone https://github.com/DeadSwitch404/vault-crypt.git
cd vault-crypt
```

### Copy and configure your env:

```bash
cp examples/sample.env .env.pwmanager
nano .env.pwmanager
```

### Make the script executable:

```bash
chmod +x vault-crypt.sh
```
### Test your GPG setup:

```bash
gpg --list-keys
```

## 🛠️ Commands

```bash
./vault-crypt.sh encrypt    # Encrypt and sign the KeePass DB
./vault-crypt.sh decrypt    # Decrypt and validate the vault
./vault-crypt.sh status     # Show vault state
./vault-crypt.sh backup     # Create encrypted, timestamped backup
./vault-crypt.sh help       # Show usage
```

## 🧪 Example .env.pwmanager

```text
KEY_ID="deadbeef42"
PW_DIR="$HOME/vault/passwords"
CLEAR_PW_DB="secrets.kdbx"
CRYPT_PW_DB="secrets.kdbx.gpg"
BACKUP_DIR="$HOME/vault/backups"
TIMESTAMP=$(date +"%Y%m%d-%H%M")
CURRENT_DIR="$PWD"
```

### Important:

Keep this .env file outside of version control.
DeadSwitch recommends using chmod 600 and storing it on encrypted storage.

## 🧹 Bonus: Harden Your Flow

- Use shred or srm to wipe files on exit (manual or optional enhancement).
- Alias vault-crypt.sh decrypt to open-sesame for that final hacker vibe.
- Run via cron for daily encrypted backups to external storage (offline preferred).

## 🕳️ Backdoor-Free Guarantee

`grep -r curl .`
(nothing found)

`grep -r wget .`
(silence)

# You’re home.

## 🪪 License

MIT.

Use. Fork. Adapt. Ghost away.

But respect the silence. Credit DeadSwitch.



DeadSwitch | The Cyber Ghost
"You don't need permission to protect what’s yours."


https://tomsitcafe.com
https://github.com/DeadSwitch404/vault-crypt
