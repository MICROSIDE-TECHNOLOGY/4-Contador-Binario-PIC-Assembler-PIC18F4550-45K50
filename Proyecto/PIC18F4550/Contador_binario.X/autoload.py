import shutil
import os
# log is an object that makes the MPLAB X logger available to scripts. The logger is setup
# in the IDE via Tools->Options->Embedded->Diagnostic. See documentation at the bottom of this file.

# avoid having the log information be tee'd into the output window
log.setShowOutput(False)

#
def onload(ide):
    ide.addCommand("Export HEX - release", "cmd_release")

def cmd_release():
    found = False
    if(os.path.exists("dist/default/production/")):
        files = os.listdir("dist/default/production/")
        for file in files:
            if file.endswith(".hex"):
                hex_path = "dist/default/production/" + file
                shutil.copy(hex_path, "../")
                found = True
        
    if found:
        msg.print("Done\n")
    else:
        error_msg = """
                    Please build your project as release\n
                    Production->Build project\n
                    """
        msg.msg(error_msg, "ERROR")