#!/bin/bash

usage() {
  echo "Usage: $0 -v version"
  exit 1
}

VERSION="1.23.0"

while getopts "v:" opt; do
  case $opt in
    v) VERSION="$OPTARG" ;;
    *) usage ;;
  esac
done

# Ensure a version was provided
if [ -z "$VERSION" ]; then
  usage
fi

# Variables
CHARTS_DIR="chart/charts"

# Clean up any existing output directory
rm -rf $CHARTS_DIR
mkdir -p $CHARTS_DIR

# Use kpt to aggregate the charts into the Helm chart's charts directory
kpt pkg get "https://github.com/istio/istio.git/manifests/charts/base@$VERSION" "$CHARTS_DIR/base"
kpt pkg get "https://github.com/istio/istio.git/manifests/charts/istio-control/istio-discovery@$VERSION" "$CHARTS_DIR/istiod"
kpt pkg get "https://github.com/istio/istio.git/manifests/charts/istio-cni@$VERSION" "$CHARTS_DIR/istio-cni"
kpt pkg get "https://github.com/istio/istio.git/manifests/charts/ztunnel@$VERSION" "$CHARTS_DIR/ztunnel"

# Inform the user that the aggregation is complete
echo "kpt aggregation complete. Files are available in: $CHARTS_DIR"
