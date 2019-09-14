# -*- coding: utf-8 -*-

import os

cmd = f"git submodule update --recursive --remote"
print("running", cmd)
ret = os.system(
    cmd
)
print(ret)
