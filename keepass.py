#!/bin/env python3

import os
from pathlib import Path
home = Path(os.path.expanduser("~"))
config_path = home.joinpath(".config/keepassxc/keepassxc.ini")
config = open(config_path, "r")
def startswith_multiple(string, list):
    for i in list:
        if string.startswith(i):
            return True

blocks=config.read().split("\n\n")
preserved_blocks=list(
    filter(
        lambda x: not startswith_multiple(x, ["[General]", "[FdoSecrets]", "[GUI]"])
        , blocks)
)
preserved_blocks.extend(["""
[General]
BackupBeforeSave=true
ConfigVersion=2
MinimizeAfterUnlock=false
""",
"""
[FdoSecrets]
Enabled=true
""",
"""
[GUI]
Language=en_US
MinimizeOnClose=true
MinimizeOnStartup=false
MinimizeToTray=true
ShowTrayIcon=true
TrayIconAppearance=monochrome-light
""",])
preserved_blocks = [x.strip() for x in preserved_blocks]
new_config = "\n\n".join(preserved_blocks)
print(new_config)
open(config_path, "w").write(new_config)
