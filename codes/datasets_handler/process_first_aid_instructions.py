from datasets import load_dataset
from pathlib import Path
from tqdm import tqdm
import os

from utils.helper import generate_message, write_messages_to_json
from utils.combine_jsonl import combine_jsonl_files


DATASET_TARGET_PATH = (
    '/root/directory/datasets/training/first_aid_instructions.jsonl')

if __name__ == "__main__":
    ds = load_dataset(
        "lextale/FirstAidInstructionsDataset",
        split="FirstAidQA"
    )

    Path(DATASET_TARGET_PATH).parent.mkdir(parents=True, exist_ok=True)

    messages = []
    for i_row, row in tqdm(enumerate(ds)):
        if row["question"].strip() is not None and row["answer"].strip() is not None and row["answer"].strip() != "":
            messages.append(
                generate_message(row["question"].strip(), row["answer"].strip())
            )

    write_messages_to_json(
        DATASET_TARGET_PATH,
        messages
    )
