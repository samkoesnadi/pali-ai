from datasets import load_dataset
from pathlib import Path
from tqdm import tqdm
import os

from utils.helper import generate_message, write_messages_to_json
from utils.combine_jsonl import combine_jsonl_files


DATASET_TARGET_PATH = (
    '/root/directory/datasets/training/city_country.jsonl')

if __name__ == "__main__":
    ds = load_dataset(
        "gabrielwu/city_country",
        split="train"
    )

    Path(DATASET_TARGET_PATH).parent.mkdir(parents=True, exist_ok=True)

    messages = []
    for row in tqdm(ds):
        if row["question"] is not None and row["answer0"] is not None:
            messages.append(
                generate_message(row["question"], row["answer0"])
            )

    write_messages_to_json(
        DATASET_TARGET_PATH,
        messages
    )

    # Path(DATASET_TARGET_PATH).parent.mkdir(parents=True, exist_ok=True)
    # combine_jsonl_files(DATASET_ROOT_DIR, DATASET_TARGET_PATH)
