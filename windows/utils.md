## Modalità ibernazione

- `powercfg.exe -h off`
- `powercfg.exe -h on`

## backup selected files from wsl to a Windows folder

``` rsync -zarv  --prune-empty-dirs --include "*/" --include="*.env" --include="*.phpstan.neon" --include="*.php-cs-fixer.php" --include="docker-php" --include=".vscode/***"  --exclude="vendor/***"  --exclude="*"  www "/mnt/c/target/path"```