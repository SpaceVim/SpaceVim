import sys

from pathlib import Path


BASE_DIR = Path(__file__).parent.parent
sys.path.insert(0, str(BASE_DIR.joinpath('rplugin/python3')))
