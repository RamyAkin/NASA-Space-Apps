#!/bin/bash
set -e

# Root-level wrapper: navigate into exoplanet_ai and run its start script
cd "$(dirname "$0")/exoplanet_ai"
exec ./start.sh
