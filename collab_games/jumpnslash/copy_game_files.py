import os
import shutil
import time

# copy the files named in this list
copy_files = [
    "jumpnslash.p8",
    "rooms.p8",
    "player.p8"]

# the files in the to_copy list are all found in the following directory
from_folder = "C:\Users\henry\Documents\GitHub\jump-n-slash\jumpnslash-pico8"

# the files in the to_copy list will be copied into the following directory
to_folder = "C:\Users\henry\AppData\Roaming\pico-8\carts\collab_games\jumpnslash"

for fi in range(len(copy_files)):
    fname = copy_files[fi]
    from_path = os.path.join(from_folder, fname)
    to_path = os.path.join(to_folder, fname)
    shutil.copy(from_path, to_path)
    #print(f"copied {fname}\n\tsrc: {from_folder}\n\tdst: {to_folder}")
    print("copied!")
    time.sleep(1)
