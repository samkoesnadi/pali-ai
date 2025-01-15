import os
import json
from tqdm import tqdm
import argparse
from pathlib import Path

def combine_jsonl_files(folder_path, output_file):
    # Open the output file in write mode
    with open(output_file, 'w', encoding='utf-8') as outfile:
        # Iterate over all files in the folder
        for filename in tqdm(os.listdir(folder_path)):
            if filename.endswith('.jsonl'):
                file_path = os.path.join(folder_path, filename)
                # Open each .jsonl file and write its contents to the output file
                with open(file_path, 'r', encoding='utf-8') as infile:
                    for line in infile:
                        outfile.write(line)

if __name__ == "__main__":
    # Set up argument parsing
    parser = argparse.ArgumentParser(description="Combine multiple .jsonl files into a single file.")
    parser.add_argument('--folder_path', type=str, required=True, help='Path to the folder containing .jsonl files')
    parser.add_argument('--output_file', type=str, required=True, help='Name of the output .jsonl file')

    # Parse the arguments
    args = parser.parse_args()

    # Call the function with the provided arguments
    Path(args.output_file).parent.mkdir(parents=True, exist_ok=True)
    combine_jsonl_files(args.folder_path, args.output_file)
