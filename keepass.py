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
preserved_blocks.extend(["""\
[General]
BackupBeforeSave=true
ConfigVersion=2
MinimizeAfterUnlock=true""",
"""\
[FdoSecrets]
Enabled=true
""",
"""\
[GUI]
Language=en_US
MinimizeOnClose=true
MinimizeOnStartup=true
MinimizeToTray=true
ShowTrayIcon=true
TrayIconAppearance=monochrome-light
""",])
print("\n\n".join(blocks))
