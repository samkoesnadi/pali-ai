import os
import json
import argparse
from pathlib import Path

from lmdeploy import pipeline, TurbomindEngineConfig, GenerationConfig, ChatTemplateConfig
from tqdm import tqdm
import argostranslate.package
import argostranslate.translate

from datasets.utils.helper import generate_message


model_name = "internlm/internlm2_5-7b-chat-4bit"
engine_config = TurbomindEngineConfig(model_format="awq")
# chat_template_config = ChatTemplateConfig(
#     model_name,
#     meta_instruction="You are PALI, an offline AI assistant developed by Technology Robot in Indonesia."
# )
pipe = pipeline(
    model_name, backend_config=engine_config,
    # chat_template_config=chat_template_config
)
gen_config = GenerationConfig(top_k=1,
                              temperature=0.0,
                              max_new_tokens=512)

assistant_message_prompt = "Convert the following text to a longer text. Maximum 200 words\n---\n{}"
# user_message_prompt = "Fix the grammar of the following text\n---\n{}"

translate_assistant_message_prompt = "Translate the following text to {}\n---\n{}"

def download_argos_translate(from_code, to_code):
    # Download and install Argos Translate package
    argostranslate.package.update_package_index()
    available_packages = argostranslate.package.get_available_packages()
    package_to_install = next(
        filter(
            lambda x: x.from_code == from_code and x.to_code == to_code, available_packages
        )
    )
    argostranslate.package.install_from_path(package_to_install.download())

extra_languages = ["id", "de", "es"]

translated_user_messages = {
    "id": "Deskripsikan lokasi pada gambar ini",
    "de": "Beschreiben Sie den Ort auf diesem Bild",
    "es": "Describe la ubicaci\u00f3n en esta imagen",
}

for language in extra_languages:
    download_argos_translate("en", language)

file_list = [
    # "tr_id.jsonl",
    # "first_aid_instructions.jsonl",
    "reddit_qa_filtered.jsonl",
]


def debug_print(label, old, new):
    print()
    # print("Old user message:")
    # print(user_message)
    # print()
    # print("New user message:")
    # print(new_user_message)
    # print()
    print(f"Old {label}:")
    print(old)
    print()
    print(f"New {label}:")
    print(new)
    print()

def process_jsonl_line(line):
    """
    Placeholder function to process a single line from a JSONL file.
    
    Args:
        line (str): A single line from a JSONL file.
    
    Returns:
        dict: The parsed JSON object.
    """
    try:
        # Parse the JSON line
        data = json.loads(line)

        user_message = data["messages"][0]["content"]
        assistant_message = data["messages"][1]["content"]

        # new_user_message = pipe(user_message_prompt.format(user_message.strip())).text
        new_assistant_message = pipe(assistant_message_prompt.format(assistant_message.strip()), gen_config=gen_config).text
        debug_print("assistant message", assistant_message, new_assistant_message)

        generated_messages = [generate_message("Describe the location in this picture", new_assistant_message, data["images"][0])]

        for language in extra_languages:
            # translated_new_user_message = pipe(
            #     translate_assistant_message_prompt.format(language, user_message.strip()), gen_config=gen_config
            # ).text
            # translated_new_assistant_message = pipe(
            #     translate_assistant_message_prompt.format(language, new_assistant_message.strip()), gen_config=gen_config
            # ).text

            # translated_new_user_message = language.translate(user_message)
            # translated_new_assistant_message = language.translate(new_assistant_message)

            translated_new_user_message = translated_user_messages[language]
            translated_new_assistant_message = argostranslate.translate.translate(
                new_assistant_message, "en", language
            )

            debug_print(f"translated messages in {language}", translated_new_user_message, translated_new_assistant_message)

            generated_messages.append(
                generate_message(translated_new_user_message, translated_new_assistant_message, data["images"][0])
            )

        return generated_messages
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON: {e}")
        return None


def process_jsonl_files(input_dir, output_dir):
    """
    Process all JSONL files in the specified input directory and save the processed lines to new JSONL files in the output directory.
    
    Args:
        input_dir (str): Path to the directory containing input JSONL files.
        output_dir (str): Path to the directory where processed JSONL files will be saved.
    """
    # Convert input and output directories to Path objects
    input_dir = Path(input_dir)
    output_dir = Path(output_dir)
    
    # Create the output directory if it doesn't exist
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Check if the input directory exists
    if not input_dir.is_dir():
        print(f"Error: Input directory '{input_dir}' does not exist.")
        return

    file_paths = file_list if file_list is not None else os.listdir(input_dir)

    # Iterate over all files in the input directory
    for filename in file_paths:
        if filename.endswith(".jsonl"):
            input_file_path = input_dir / filename
            output_file_path = output_dir / filename
            
            print(f"Processing file: {input_file_path}")
            
            # Check if the output file exists
            if output_file_path.exists():
                # Calculate the start_line based on the number of lines in the output file
                with open(output_file_path, 'r') as output_file:
                    num_lines = sum(1 for _ in output_file)
                start_line = num_lines // (len(extra_languages) + 1)
                file_mode = 'a'  # Append mode
            else:
                start_line = 0  # No start_line if the file doesn't exist
                file_mode = 'w'  # Write mode

            # Open the input file and the output file in the appropriate mode
            with open(input_file_path, 'r') as input_file, open(output_file_path, file_mode) as output_file:
                # Skip lines until the desired start line
                for _ in range(start_line):
                    next(input_file, None)  # Skip the line

                # Process the remaining lines
                for line in tqdm(input_file):
                    # Process the line
                    processed_data = process_jsonl_line(line.strip())

                    # If the line was successfully processed, write it to the output file
                    if processed_data:
                        for processed_datum in processed_data:
                            output_file.write(json.dumps(processed_datum) + "\n")


def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(description="Process JSONL files in a target directory and save the results to another directory.")
    parser.add_argument(
        "--input_dir",
        type=str,
        help="Path to the directory containing input JSONL files.",
        default='/home/sami/Documents/projects/technology-robot/datasets/images/training',
    )
    parser.add_argument(
        "--output_dir",
        type=str,
        help="Path to the directory where processed JSONL files will be saved.",
        default='/home/sami/Documents/projects/technology-robot/datasets/images/processed_training'
    )
    
    # Parse arguments
    args = parser.parse_args()
    
    # Process the JSONL files and save the results
    process_jsonl_files(args.input_dir, args.output_dir)


if __name__ == "__main__":
    main()
