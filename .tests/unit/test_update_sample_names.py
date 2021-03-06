import os
import sys

import subprocess as sp
from tempfile import TemporaryDirectory
import shutil
from pathlib import Path, PurePosixPath

sys.path.insert(0, os.path.dirname(__file__))

import common


def test_update_sample_names():

    with TemporaryDirectory() as tmpdir:
        workdir = Path(tmpdir) / "workdir"
        data_path = PurePosixPath(".tests/unit/update_sample_names/data")
        expected_path = PurePosixPath(".tests/unit/update_sample_names/expected")
        config_path = PurePosixPath(".tests/unit/config")

        # Copy data to the temporary workdir.
        shutil.copytree(data_path, workdir)
        shutil.copytree(config_path, workdir / "config")

        # dbg
        print("results/joint_calls/G1.vcf.gz", file=sys.stderr)

        # Run the test job.
        sp.check_output(
            [
                "python",
                "-m",
                "snakemake",
                "results/joint_calls/G1.vcf.gz",
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
        common.VcfGzChecker(data_path, expected_path, workdir).check()
