# Compiles Boriel Basic source file and creates a NEX file
import sys
import os
from pathlib import Path

# Compilation parameters
ORG = "32768"
HEAP = "2048"
OPTIMIZE = "4"

# Specify loading screen
BMP_FILE = None

# Directory setup
workspace_dir = os.getcwd()
compiler_dir = os.path.abspath("../../../tools/zxbasic-1.17.3")
compiler_lib_dir = os.path.join(compiler_dir, "src/lib/arch/zxnext/stdlib")
build_dir_relative = "./build/"
build_dir = os.path.abspath(os.path.join(workspace_dir, "build"))
source_dir = os.path.abspath(os.path.join(workspace_dir, "src"))

# Source file handling
source_file = sys.argv[1]
base_name = Path(source_file).stem
nex_config_file = os.path.join(source_dir, f"{base_name}.cfg")

# Add compiler directory to system path
sys.path.append(compiler_dir)
from src.zxbc import zxbc, version
from tools import nextcreator

# Compilation process
print(f"Compiling    :  {source_file}")
print(f"ZXbasic ver  :  {version.VERSION}")

errno = zxbc.main([
    source_file,
    "-S", ORG,
    "-O", OPTIMIZE,
    "-H", HEAP,
    "--explicit",
    "--arch", "zxnext",
    "-M", os.path.join(build_dir_relative, "Memory.txt"),
    "-o", os.path.join(build_dir_relative, f"{base_name}.bin"),
    "-I", compiler_lib_dir
])

if errno != 0:
    sys.exit(-1)

# NEX file creation
try:
    nextcreator.parse_file(nex_config_file)
    nextcreator.generate_file(os.path.join(build_dir_relative, f"{base_name}.nex"))
except Exception:
    print("ERROR creating NEX file!")
    sys.exit(-2)

print("Finished")
sys.exit(0)
