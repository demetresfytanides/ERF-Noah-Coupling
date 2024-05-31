# Module for build managing directory tree

import os, sys, glob

for path in os.getenv("PYMODULE_PATH").split(":"):
    sys.path.insert(0, path)

import api


def infer_src_mapping(sfile, mapping):
    fi_prompt = ["Write FORTRAN part of the FORTRAN-C interface."]
    ci_prompt = ["Write the Extern C part of the FORTRAN-C interface."]

    return fi_prompt, ci_prompt


def create_src_mapping(dest):
    """
    Build directory tree from neucol source code.

    Arguments
    ---------
    dest : String value of destination directory
    """
    src_dir = os.getenv("NOAH_HOME") + os.sep + "src"
    dest_dir = os.getenv("NOAH_HOME") + os.sep + dest

    if os.path.exists(dest_dir):
        user_decision = api.get_user_input(
            f'Destination "{dest}" already exists continue? (Y/n)'
        )
        if user_decision.upper() == "Y":
            api.display_output(
                "Please note that existing files will not be replaced in the destination."
            )
        elif user_decision.upper() == "N":
            api.display_output("Exiting application based on user decision")
        else:
            api.display_output(f'Unknown option "{user_option}"')
            raise ValueError

    else:
        api.display_output(f'Creating destination directory "{dest}"')
        for item in os.walk(src_dir):
            sub_dir = item[0].replace(src_dir, "")
            os.makedirs(dest_dir + os.sep + sub_dir)

    src_f90_files = []
    dest_fi_files = []
    dest_ci_files = []

    for item in os.walk(src_dir):

        sub_dir = item[0].replace(src_dir, "")

        for file in item[2]:
            if file.endswith((".F90")):
                src_f90_files.append(src_dir + os.sep + sub_dir + os.sep + file)

                dest_ci_files.append(
                    dest_dir
                    + os.sep
                    + sub_dir
                    + os.sep
                    + file.replace(".F90", "_ci.cxx")
                )
                dest_fi_files.append(
                    dest_dir
                    + os.sep
                    + sub_dir
                    + os.sep
                    + file.replace(".F90", "_fi.F90")
                )

            else:
                continue
                # raise ValueError(f"Unrecognized extension for file: {file}")

    mapping = {
        "src": {"f90_files": src_f90_files, "dir": src_dir},
        "dest": {"fi_files": dest_fi_files, "ci_files": dest_ci_files, "dir": dest_dir},
    }

    return mapping
