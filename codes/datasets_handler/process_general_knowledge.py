from datasets import load_dataset
from pathlib import Path
from tqdm import tqdm
import os

from utils.helper import generate_message, write_messages_to_json
from utils.combine_jsonl import combine_jsonl_files


DATASET_TARGET_PATH = (
    '/root/directory/datasets/training/general_knowledge.jsonl')

if __name__ == "__main__":
    ds = load_dataset(
        "MuskumPillerum/General-Knowledge",
        split="train"
    )

    Path(DATASET_TARGET_PATH).parent.mkdir(parents=True, exist_ok=True)

    messages = []
    for row in tqdm(ds):
        if row["Question"] is not None and row["Answer"] is not None:
            messages.append(
                generate_message(row["Question"], row["Answer"])
            )

    write_messages_to_json(
        DATASET_TARGET_PATH,
        messages
    )
