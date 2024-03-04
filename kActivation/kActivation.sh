#!/bin/bash

WINE="@wine@/bin/wine"

exec "$WINE" "@out@/bin/kActivation.exe" "$@"
