import os
import sys

import subprocess as sp
from tempfile import TemporaryDirectory
import shutil
from pathlib import Path, PurePosixPath

sys.path.insert(0, os.path.dirname(__file__))

import common


def test_fastp_pe():

    with TemporaryDirectory() as tmpdir:
        workdir = Path(tmpdir) / "workdir"
        data_path = PurePosixPath(".tests/unit/fastp_pe/data")
        expected_path = PurePosixPath(".tests/unit/fastp_pe/expected")
        config_path = PurePosixPath(".tests/unit/config")

        # Copy data to the temporary workdir.
        shutil.copytree(data_path, workdir)
        shutil.copytree(config_path, workdir / "config")

        # dbg
        print(
            "results/trimmed/A-1.1.fastq.gz results/trimmed/A-1.2.fastq.gz results/qc/fastp/A-1.html results/qc/fastp/A-1.json",
            file=sys.stderr,
        )

        # Run the test job.
        sp.check_output(
            [
                "python",
                "-m",
                "snakemake",
                "results/trimmed/A-1.1.fastq.gz",
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

        # Check the output byte by byte using cmp.
        # To modify this behavior, you can inherit from common.OutputChecker in here
        # and overwrite the method `compare_files(generated_file, expected_file),
        # also see common.py.
        common.OutputChecker(data_path, expected_path, workdir).check()
