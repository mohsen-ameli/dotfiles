#!/bin/bash
# Export passwords from UNIX Password Manager for use in bitwarden and vaultwarden in JSON format.
# Just double check the file for multi line problems or other issues before importing.

shopt -s nullglob globstar
prefix=${PASSWORD_STORE_DIR:-$HOME/.password-store}

target_file="/tmp/passwords_from_pass.json"
cat > "$target_file" <<EOF
{
  "encrypted": false,
  "folders": [],
  "items": [
EOF

echo -e "Exporting passwords to $target_file"
i=0

for file in "$prefix"/**/*.gpg; do
    ((i++))
    file="${file/$prefix//}"

    decrypted_content=$(pass "${file%.*}")
    name="${file%.*}"
    name="${name##//}"
    password=$(echo "$decrypted_content" | head -n 1 | sed 's/\\/\\\\/g; s/"/\\"/g')
    username=$(echo "$decrypted_content" | grep -E '^(email|username):' | head -n 1 | cut -d: -f2- | sed 's/\\/\\\\/g; s/^[ \t]*//; s/"/\\"/g')
    totp=$(echo "$decrypted_content" | grep otpauth)
    url=$(echo "$decrypted_content" | grep -E '^(url|www|website):' | head -n 1 | cut -d: -f2- | sed 's/\\/\\\\/g; s/^[ \t]*//; s/"/\\"/g')
    notes=$(echo "$decrypted_content" | grep -E '^(note|notes): ' | cut -d: -f2- | sed 's/\\/\\\\/g; s/^[ \t]*//; s/"/\\"/g')

    cat >> "$target_file" <<EOF 
    {
        "passwordHistory": null,
        "revisionDate": "$(date +%Y-%m-%dT%H:%M:%S.%3NZ)",
        "creationDate": "$(date +%Y-%m-%dT%H:%M:%S.%3NZ)",
        "deletedDate": null,
        "id": "$(uuidgen)",
        "organizationId": null,
        "folderId": null,
        "type": 1,
        "reprompt": 0,
        "name": "$name",
        "notes": "$notes",
        "favorite": false,
        "login": {
            "fido2Credentials": [],
            "uris": [
            {
                "match": null,
                "uri": "$url"
            }
            ],
            "username": "$username",
            "password": "$password",
            "totp": "$totp"
        },
        "collectionIds": null
    }
    ,
EOF
done

sed -i '$d' "$target_file"
cat >> "$target_file" <<EOF 
    ]
}
EOF

echo "Exported $i successfully!"




# export passwords to external file

# shopt -s nullglob globstar
# prefix=${PASSWORD_STORE_DIR:-$HOME/.password-store}

# target_file="/tmp/passwords_from_pass"
# echo "Exporting passwords to $target_file"

# for file in "$prefix"/**/*.gpg; do
#     file="${file/$prefix//}"
#     printf "%s\n" "Name: ${file%.*}" >> "$target_file"
#     pass "${file%.*}" >> "$target_file"
#     printf "\n\n" >> "$target_file"
# done
