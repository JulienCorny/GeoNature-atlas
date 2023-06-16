import os
from pathlib import Path

default_atlas_config_file_path=Path(__file__).parent / 'config.py'
default_atlas_static_folder=Path(__file__).parent.parent / 'static'
default_atlas_template_folder=Path(__file__).parent.parent

atlas_config_file_path=os.environ.get("ATLAS_SETTINGS", default_atlas_config_file_path)
atlas_static_folder = os.environ.get("ATLAS_STATIC_FOLDER", default_atlas_static_folder)
atlas_template_folder = os.environ.get("ATLAS_TEMPLATE_FOLDER", default_atlas_static_folder)
