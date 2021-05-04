import os
import sys

import subprocess as sp
from tempfile import TemporaryDirectory
import shutil
from pathlib import Path, PurePosixPath

sys.path.insert(0, os.path.dirname(__file__))

import common


def test_integration():

    with TemporaryDirectory() as tmpdir:
        workdir = Path(tmpdir) / "workdir"
        data_path = PurePosixPath(".tests/integration/data")
        expected_path = PurePosixPath(".tests/integration/expected")
        config_path = PurePosixPath(".tests/integration/config")

        # Copy data to the temporary workdir.
        shutil.copytree(data_path, workdir)
        shutil.copytree(config_path, workdir / "config")

        # dbg
        target = "results/merged_calls/all.vcf.gz"
        print(target, file=sys.stderr)

        # Run the test job.
        sp.check_output(
            [
                "python",
                "-m",
                "snakemake",
                target,
                "-j1",
                "--keep-target-files",
                "--use-conda",
                "--conda-frontend",
                "mamba",
                "--use-singularity",
                "--directory",
                workdir,
            ]
        )

        common.compare_vcfs(
                workdir / target,
                expected_path / target
                )
