#!/bin/bash

pharo Pharo.image cosmos \
  --port="${PORT:-8090}" \
  --allowed-origins="${ALLOWED_ORIGINS:-http://localhost}"