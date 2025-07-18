#!/usr/bin/env bash

# vault-crypt.sh
# DeadSwitch | The Silent Architect

set -euo pipefail  # Exit on error, unset var, or pipeline failure
IFS=$'\n\t'

source .env.pwmanager  # Load env variables (KEY_ID, PW_DIR, etc.)

echo -e "[+] Entering the crypt... $PW_DIR"
cd "$PW_DIR" || exit 1

encrypt_vault() {
    if [[ ! -f "$CRYPT_PW_DB" ]]; then
        echo -e "[+] Securing the password vault..."
        if gpg --encrypt --sign --local-user "$KEY_ID" --recipient "$KEY_ID" "$CLEAR_PW_DB"; then
            echo -e "[+] The vault is sealed: ${CRYPT_PW_DB}"
            echo -e "[+] Verifying the seal..."
            if gpg --decrypt "$CRYPT_PW_DB" 2>&1 | grep -q "Good signature from"; then
                echo -e "[+] Signature verified: signed by $KEY_ID"
                echo -e "[+] Purging the unencrypted vault..."
                rm -f "$CLEAR_PW_DB"
                echo -e "[+] Encryption complete."
                return 0
            else
                echo -e "[!] Signature verification failed!"
                return 1
            fi
        else
            echo -e "[!] Encryption failed!"
            return 1
        fi
    else
        echo -e "[!] Encrypted vault already exists. Abort."
        return 1
    fi
}

decrypt_vault() {
    if [[ -f "$CRYPT_PW_DB" && ! -f "$CLEAR_PW_DB" ]]; then
        echo -e "[+] Unlocking the vault..."
        if gpg --decrypt --output "$CLEAR_PW_DB" "$CRYPT_PW_DB"; then
            echo -e "[+] Vault unlocked: $CLEAR_PW_DB"
            echo -e "[+] Shredding the encrypted seal..."
            rm -f "$CRYPT_PW_DB"
            echo -e "[+] Decryption complete."
            return 0
        else
            echo -e "[!] Decryption failed!"
            return 1
        fi
    else
        echo -e "[!] Cannot decrypt. Either vault is already open or encrypted file is missing."
        return 1
    fi
}

vault_status() {
    if [[ -f "$CRYPT_PW_DB" ]]; then
        echo -e "[+] The database is ENCRYPTED (Last modified: $(stat -c %y "$CRYPT_PW_DB"))"
    else
        echo -e "[+] The database is DECRYPTED (Last modified: $(stat -c %y "$CLEAR_PW_DB"))"
    fi
}

backup_vault() {
    echo -e "[+] Starting backup process..."

    # Ensure the backup directory exists
    mkdir -p "$BACKUP_DIR"

    if [[ ! -f "$CRYPT_PW_DB" ]]; then
        echo -e "[!] Database is not encrypted! Encrypting now..."
        if ! encrypt_vault; then
            echo -e "[!] Encryption failed, aborting backup."
            return 1
        fi
    fi

    # Create a timestamped backup
    BACKUP_FILE="$BACKUP_DIR/$TIMESTAMP-stuff.kdbx.gpg"
    cp "$CRYPT_PW_DB" "$BACKUP_FILE"

    # Verify that the backup was successful
    if [[ -f "$BACKUP_FILE" ]]; then
        echo -e "[+] Backup successful: $BACKUP_FILE"
    else
        echo -e "[!] Backup failed!"
        return 1
    fi
}

help_text() {
    echo -e "\nDeadSwitch Vault Manager"
    echo -e "Usage: $0 {encrypt|decrypt|status|backup|help}\n"
    echo -e "Commands:"
    echo -e "  encrypt   Encrypt and sign the KeePass database"
    echo -e "  decrypt   Decrypt the encrypted KeePass database"
    echo -e "  status    Write out the status of the database"
    echo -e "  backup    Backup & encrypt the database"
    echo -e "  help      Show this guide\n"
    echo -e "DeadSwitch | The Cyber Ghost"
    echo -e "\"In silence, we rise. In the switch, we fade.\"\n"
    exit 0
}

case "${1:-}" in
    encrypt)
	encrypt_vault || echo "[!] Vault encryption failed!"
        ;;

    decrypt)
	decrypt_vault || echo "[!] Vault decryption failed!"
        ;;

    status)
	vault_status
	;;

    backup)
        backup_vault || echo "[!] Vault backup failed!"
        ;;

    help|--help|-h)
	help_text
        ;;

    *)
        echo -e "Try: $0 help"
        exit 1
        ;;
esac

cd "$CURRENT_DIR" || exit 1  # Ensure we return to the original directory
