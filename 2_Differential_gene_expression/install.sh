#!/usr/bin/env bash
# Install the differential-expression conda environment and link it to Jupyter.
# Run `bash install.sh --help` for usage.
set -euo pipefail

NAME=differential-expression
YML=${NAME}.yml

usage() {
    cat <<EOF
Install the '${NAME}' conda environment and link it to Jupyter.

Usage: bash install.sh [--apple-silicon]

Run from the 2_Differential_gene_expression directory.

Options:
  --apple-silicon   Install Intel (osx-64) packages instead of arm64. Use this
                    on Macs with Apple silicon (M1/M2/M3/...), where many
                    bioconductor packages have no native build. 
  -h, --help        Show this message and exit.
EOF
}

# Parse the (single, optional) flag.
APPLE_SILICON=false
case "${1:-}" in
    --apple-silicon) APPLE_SILICON=true ;;
    -h|--help) usage; exit 0 ;;
    "") ;;
    *) echo "Unknown option: $1" >&2; echo >&2; usage >&2; exit 1 ;;
esac

echo "Creating conda environment '${NAME}' from ${YML}"
if [[ "${APPLE_SILICON}" == true ]]; then
    echo "Installing osx-64 packages for Apple silicon."
    CONDA_SUBDIR=osx-64 conda env create -f "${YML}"
    # Pin the new environment to osx-64 so future package installs use it too.
    # `--env` targets the active environment, so run it via `conda run -n` to
    # write to differential-expression's config rather than base's.
    conda run -n "${NAME}" conda config --env --set subdir osx-64
else
    conda env create -f "${YML}"
fi

echo "Linking '${NAME}' to Jupyter via IRkernel"
# `conda activate` needs conda's shell hook, which isn't loaded in a
# non-interactive script; `conda run` sidesteps that.
conda run -n "${NAME}" Rscript -e "IRkernel::installspec(name = '${NAME}', displayname = '${NAME}')"

echo "Done. Activate the environment with: conda activate ${NAME}"
