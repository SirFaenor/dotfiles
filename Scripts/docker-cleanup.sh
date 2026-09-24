#!/bin/bash

set -e

if ! command -v docker >/dev/null 2>&1; then
  echo "Errore: docker non trovato. Installa Docker Desktop o avvialo." >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Errore: il daemon Docker non è in esecuzione. Avvia Docker Desktop." >&2
  exit 1
fi

echo "==> Spazio occupato da Docker prima della pulizia:"
docker system df

echo
echo "==> 1/3 Rimozione immagini inutilizzate..."
docker image prune -a -f

echo
echo "==> 2/3 Rimozione volumi inutilizzati..."
docker volume prune -f

echo
echo "==> 3/3 Rimozione cache di build..."
docker builder prune -f

echo
echo "==> Spazio occupato da Docker dopo la pulizia:"
docker system df
