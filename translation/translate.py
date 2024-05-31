# Prompt engineering for building diffusion stencils for constant and variable coefficient equation

# Import libraries
import os, sys

for path in os.getenv("PYMODULE_PATH").split(":"):
    sys.path.insert(0, path)

import api, noah

from typing import Optional
import fire, transformers, torch
from alive_progress import alive_bar


def main(
    max_new_tokens: int = 4096,
    batch_size: int = 8,
    max_length: Optional[int] = None,
):

    llm_choice = api.get_user_input(
        f"LLM powered code conversion tool that uses the transformers API "
        + f"to test different models.\n\t1. mistral-7b\n\t2. codellama-7b\n\t3. gemma-7b\nSelect "
        + f"the model you would like to interact with"
    )

    if int(llm_choice) == 1:
        ckpt_dir = os.getenv("MODEL_HOME") + os.sep + "mistral/Mistral-7B-Instruct-v0.1"
    elif int(llm_choice) == 2:
        ckpt_dir = (
            os.getenv("MODEL_HOME") + os.sep + "codellama/CodeLlama-7b-Instruct-hf"
        )
    elif int(llm_choice) == 3:
        ckpt_dir = os.getenv("MODEL_HOME") + os.sep + "google/gemma-7b-it"
    else:
        api.display_output(f"Option {llm_choice} not defined")
        raise NotImplementedError

    if not os.path.exists(ckpt_dir):
        api.display_output(
            f'Checkpoint directory does not exist for option "{llm_choice}"'
        )
        raise NotImplementedError
    else:
        api.display_output(f'Checkpoint directory exists for option "{llm_choice}"')

    dest = api.get_user_input("Enter destination folder name")
    mapping = noah.create_src_mapping(dest)

    source_dirs = api.get_user_input(
        "Enter source code directories separated by commas, use (*) for all"
    )
    source_f90_files = []
    target_fi_files = []
    target_ci_files = []

    if source_dirs == "*":
        source_f90_files.extend(mapping["src"]["f90_files"])
        target_fi_files.extend(mapping["dest"]["fi_files"])
        target_ci_files.extend(mapping["dest"]["ci_files"])

    else:
        for f90_file, fi_file, ci_file in zip(
            mapping["src"]["f90_files"],
            mapping["dest"]["fi_files"],
            mapping["dest"]["ci_files"],
        ):
            for sdir in source_dirs.split(","):
                if (sdir.strip() in f90_file) and (sdir.strip() in fi_file):
                    source_f90_files.append(f90_file)
                    target_fi_files.append(fi_file)
                    target_ci_files.append(ci_file)

    if len(source_f90_files) != len(target_fi_files):
        api.display_output(
            "source_f90_files and target_fi_files for conversion do not match in length"
        )
        raise ValueError

    api.display_output("Starting code conversion process")

    main_prompt = []
    main_prompt.append(
        "You are a code conversion tool for a scientific computing application. "
        + "The application is organized as different source files in a directory "
        + "and you will help create FORTRAN and C++ module files for EXTERN C interface."
    )
    tokenizer = transformers.AutoTokenizer.from_pretrained(ckpt_dir)

    pipeline = transformers.pipeline(
        "text-generation",
        model=ckpt_dir,
        torch_dtype=torch.float16,
        device=0,
    )

    with alive_bar(len(source_f90_files), bar="blocks") as bar:

        for f90_file, fi_file, ci_file in zip(
            source_f90_files, target_fi_files, target_ci_files
        ):

            bar.text(f90_file.replace(mapping["src"]["dir"] + os.sep, ""))
            bar()

            if not (os.path.isfile(fi_file) and os.path.isfile(ci_file)):

                with open(f90_file, "r") as source:
                    source_code = source.readlines()

                fi_prompt, ci_prompt = noah.infer_src_mapping(f90_file, mapping)
                fi_prompt.append("The following code is part of a single file")
                ci_prompt.append("The following code is part of a single file")

                with open(fi_file, "w") as destination:
                    destination.write("/*PROMPT START")
                    for prompt_line in main_prompt + fi_prompt:
                        destination.write(f"\n//{prompt_line}")
                    destination.write(f"\nPROMPT END*/\n\n")
                    chunk_size = 100

                    for lines in [
                        source_code[i : i + chunk_size]
                        for i in range(0, len(source_code), chunk_size)
                    ]:

                        instructions = [
                            dict(
                                role="user",
                                content="\n".join(main_prompt + fi_prompt)
                                + ":\n"
                                + "".join(lines),
                            )
                        ]

                        results = pipeline(
                            instructions,
                            max_new_tokens=max_new_tokens,
                            max_length=max_length,
                            batch_size=batch_size,
                            # temperature=temperature,
                            # top_p=top_p,
                            # do_sample=True,
                            eos_token_id=tokenizer.eos_token_id,
                            pad_token_id=50256,
                        )

                        for result in results:
                            destination.write(result["generated_text"][-1]["content"])

                with open(ci_file, "w") as destination:
                    destination.write("/*PROMPT START")
                    for prompt_line in main_prompt + ci_prompt:
                        destination.write(f"\n//{prompt_line}")
                    destination.write(f"\nPROMPT END*/\n\n")
                    chunk_size = 100

                    for lines in [
                        source_code[i : i + chunk_size]
                        for i in range(0, len(source_code), chunk_size)
                    ]:

                        instructions = [
                            dict(
                                role="user",
                                content="\n".join(main_prompt + ci_prompt)
                                + ":\n"
                                + "".join(lines),
                            )
                        ]

                        results = pipeline(
                            instructions,
                            max_new_tokens=max_new_tokens,
                            max_length=max_length,
                            batch_size=batch_size,
                            # temperature=temperature,
                            # top_p=top_p,
                            # do_sample=True,
                            eos_token_id=tokenizer.eos_token_id,
                            pad_token_id=50256,
                        )

                        for result in results:
                            destination.write(result["generated_text"][-1]["content"])

            else:
                continue


if __name__ == "__main__":
    fire.Fire(main)
