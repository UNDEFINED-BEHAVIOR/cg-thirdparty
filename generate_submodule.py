# -*- coding: utf-8 -*-

import os.path as osp
import os

with open("submodulelist.txt") as f:
    submod_list = f.read()

for url in submod_list.split("\n"):
    if not url:
        continue

    print(url)

    name = url.split("/")[-1].replace(".git", "")
    print(name)

    cmd = f"git submodule add {url} {name}"
    print("running", cmd)
    ret = os.system(
        cmd
    )
    print(ret)
