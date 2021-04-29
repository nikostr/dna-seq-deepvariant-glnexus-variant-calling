"""
Common code for unit testing of rules generated with Snakemake 6.2.1+1.g99d2517b.dirty.
"""

from pathlib import Path
import subprocess as sp
import os
import hashlib
import gzip


class OutputChecker:
    def __init__(self, data_path, expected_path, workdir):
        self.data_path = data_path
        self.expected_path = expected_path
        self.workdir = workdir

    def check(self):
        input_files = set(
            (Path(path) / f).relative_to(self.data_path)
            for path, subdirs, files in os.walk(self.data_path)
            for f in files
        )
        expected_files = set(
            (Path(path) / f).relative_to(self.expected_path)
            for path, subdirs, files in os.walk(self.expected_path)
            for f in files
        )
        unexpected_files = set()
        for path, subdirs, files in os.walk(self.workdir):
            for f in files:
                f = (Path(path) / f).relative_to(self.workdir)
                if str(f).startswith(".snakemake") or str(f).startswith("config") or str(f).startswith("results/logs/") or ".DB" in str(f) or str(f).endswith('.html'):
                    continue
                if f in expected_files:
                    self.compare_files(self.workdir / f, self.expected_path / f)
                elif f in input_files:
                    # ignore input files
                    pass
                else:
                    unexpected_files.add(f)
        if unexpected_files:
            raise ValueError(
                "Unexpected files:\n{}".format(
                    "\n".join(sorted(map(str, unexpected_files)))
                )
            )

    def compare_files(self, generated_file, expected_file):
        sp.check_output(["cmp", generated_file, expected_file])


class VcfGzChecker(OutputChecker):
    def calc_md5sum(self, file):
        with gzip.open(file, 'rt') as f:
            return (hashlib.md5(
                        "".join(
                            [l for l in f.readlines() if not l.startswith("##")])
                        .encode("utf-8"))
                    .hexdigest())


    def compare_files(self, generated_file, expected_file):
        if str(generated_file).endswith('vcf.gz'):
            assert  self.calc_md5sum(generated_file) == self.calc_md5sum(expected_file), \
                    "md5sum of vcfs do not match"
        else:
            sp.check_output(["cmp", generated_file, expected_file])
