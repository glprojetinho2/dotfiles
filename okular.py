#!/bin/env python3

import os
from pathlib import Path
home = Path(os.path.expanduser("~"))
config_path = home.joinpath(".config/okularpartrc")
config = open(config_path, "r")
def startswith_multiple(string, list):
    for i in list:
        if string.startswith(i):
            return True

blocks=config.read().split("\n\n")
preserved_blocks=list(
    filter(
        lambda x: not startswith_multiple(x, ["[General]", "[PageView]"])
        , blocks)
)
print(preserved_blocks)
preserved_blocks.extend(["""[General]
DisplayDocumentTitle=false
ShowEmbeddedContentMessages=false
ShowOSD=false""",
"""[PageView]
BackgroundColor=0,0,0
MouseMode=TextSelect
ShowScrollBars=false
UseCustomBackgroundColor=true""",
])
new_config = "\n\n".join(preserved_blocks)
open(config_path, "w").write(new_config)
