from datasets import load_dataset
from tqdm import tqdm
import re
import json
import os
from pathlib import Path

import utils.helper

DATASET_ROOT_DIR = '/root/directory/datasets/raw/wikipedia'


def process(text, max_headline_len=10):
    paragraphs_result = []
    current_headline = None
    current_paragraphs = []
    first_paragraph = True

    for line in text.split("\n"):
        line = line.strip()

        if (
            (line == "")
            ### filters ###
            or (re.search(r"this[\s\S]*chart[\s.,?]", line) is not None)
            or ("following table" in line)
        ):
            continue

        if (
            "references" in line.lower()
            or "see also" in line.lower()
            or "external links" in line.lower()
            or "further reading" in line.lower()
        ):
            if len(current_paragraphs) > 0 and current_headline is not None:
                paragraphs_result.append((current_headline, current_paragraphs))
                current_headline = None
                current_paragraphs = []
            break

        if len(line.split(" ")) > max_headline_len:
            if current_headline is not None or first_paragraph:
                if len(line) > 0:
                    current_paragraphs.append(line)
        else:
            if len(current_paragraphs) > 0:
                paragraphs_result.append(
                    ("Overview" if current_headline is None else current_headline,
                     current_paragraphs
                     ))
                current_paragraphs = []
                first_paragraph = False
            
            if len(line) > 0:
                current_headline = line
    return paragraphs_result


if __name__ == "__main__":
    ds = load_dataset(
        "wikimedia/wikipedia",
        "20231101.en",
    )

    Path(DATASET_ROOT_DIR).mkdir(parents=True, exist_ok=True)

    for row in tqdm(ds["train"]):
        messages = []

        processed_row = process(row["text"])

        headlines_message = ""
        for headline, paragraphs in processed_row:
            messages.append(
                generate_message(
                    f"{headline} of {row['title']}", "\n".join(paragraphs)))
            headlines_message += "* " + headline + "\n"
        headlines_message = headlines_message[:-1]

        if len(messages) == 0:
            continue

        messages.append(
            generate_message(
                f"Headlines of {row['title']}", headlines_message)
        )
        
        write_messages_to_json(
            os.path.join(DATASET_ROOT_DIR, row['title'].replace("/", "__")[:200] + ".jsonl"),
            messages
        )
