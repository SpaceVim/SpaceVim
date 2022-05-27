from pathlib import Path
import sys

BASE_DIR = Path(__file__).parent.parent
sys.path.insert(0, str(Path(BASE_DIR).joinpath('rplugin/python3')))
