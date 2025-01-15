from datasets import load_dataset
from pathlib import Path
from tqdm import tqdm
import os
import json

from utils.helper import generate_message, write_messages_to_json
from utils.combine_jsonl import combine_jsonl_files


DATASET_TARGET_PATH = (
    '/root/directory/datasets/training/mountain_survival.jsonl')

if __name__ == "__main__":
    ds = load_dataset(
        "GreatSarmad/Mountain-Survival-Guide",
        split="train"
    )

    Path(DATASET_TARGET_PATH).parent.mkdir(parents=True, exist_ok=True)

    messages = []
    for row in tqdm(ds):
        if row["question"] is not None and row["responses"]["response_b"]["response"] is not None:
            messages.append(
                generate_message(row["question"], row["responses"]["response_b"]["response"])
            )

    write_messages_to_json(
        DATASET_TARGET_PATH,
        messages
    )
