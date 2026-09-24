rsync -zarv  --prune-empty-dirs --include "*/"  --include="*.env" --include="*.envrc"  --include=".git/config" --exclude="*" /home/sirfaenor/Progetti/www "/home/sirfaenor/Progetti/Config"
