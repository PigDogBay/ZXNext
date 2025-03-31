# Compiles Boriel Basic source file and creates an asm file
import sys,os
from pathlib import Path

#Compilation parameters
ORG = "32768"
HEAP = "2048"
OPTIMIZE = "4"

compilerDir = os.path.abspath("../../tools/zxbasic-1.17.3")
compilerLibDir = os.path.join(compilerDir, 'src/lib/arch/zxnext/stdlib')
buildDirRelative = "./build/"
sourceFile = sys.argv[1]
baseName = Path(sourceFile).stem

sys.path.append(compilerDir)  # append it to the list of imports folders
from src.zxbc import zxbc, version

print("Generating Assembly: "+sourceFile)
print("ZXBasic Version: "+version.VERSION)
errno=zxbc.main([sourceFile,'-S', ORG,'-O',OPTIMIZE,'-H',HEAP,'-e',buildDirRelative+'Compile.txt','-A','-o',buildDirRelative+baseName+'.asm','-I', compilerLibDir])

if errno != 0:
    print("Error: ",errno)
    sys.exit(-1)

print("OK Finished")
sys.exit(0)
