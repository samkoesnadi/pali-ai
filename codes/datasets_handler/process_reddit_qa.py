from datasets import load_dataset
from pathlib import Path
from tqdm import tqdm
import os

from utils.helper import generate_message, write_messages_to_json
from utils.combine_jsonl import combine_jsonl_files

import requests
import mimetypes
import time
import lmdeploy

model_dir = "OpenGVLab/InternVL2_5-4B-MPO-AWQ"
prompt_format = """Given "{}", describe the location referred there. Answer straight to the point. Give minimum 10 words sentence."""

question_variations = [
    "Where was this image taken?",
    "Can you tell me the location of this photo?",
    "What is the location shown in this picture?",
    "Do you know where this image was captured?",
    "Where is this image from?",
    "What place does this image show?",
]

DATASET_IMAGES_ROOT_DIR = (
    '/root/directory/datasets/images/reddit_qa')
DATASET_TARGET_PATH = (
    '/root/directory/datasets/images/training/reddit_qa.jsonl')


def is_image_url(url, retries=3, delay=2):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
    }
    
    for attempt in range(retries):
        try:
            # Send a HEAD request to fetch headers only
            response = requests.head(url, headers=headers, allow_redirects=True)
            
            # Check if the request was successful
            if response.status_code == 200:
                # Get the Content-Type header
                content_type = response.headers.get('Content-Type', '').lower()
                
                # Check if the Content-Type starts with 'image/'
                return content_type.startswith('image/')
            elif response.status_code == 429:
                print(f"Rate limited. Retrying in {delay} seconds... (Attempt {attempt + 1}/{retries})")
                time.sleep(delay)  # Wait before retrying
            else:
                print(f"Failed to fetch URL. Status code: {response.status_code}")
                return False
        except requests.RequestException as e:
            print(f"Error checking URL: {e}")
            if attempt == retries - 1:
                return False  # Return False if all retries fail
            time.sleep(delay)

    return False  # Return False if all retries fail


def download_image(url, save_path, retries=3, delay=2):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
    }
    
    for attempt in range(retries):
        try:
            # Send a GET request to the URL
            response = requests.get(url, headers=headers, stream=True)
            
            # Check if the request was successful
            if response.status_code == 200:
                # Determine the file type from the Content-Type header
                content_type = response.headers.get('Content-Type')
                extension = mimetypes.guess_extension(content_type)
                
                if not extension:
                    raise ValueError("Could not determine file type from Content-Type")
                
                # Append the correct file extension to the save path
                save_path_with_extension = f"{save_path}{extension}"
                
                # TODO
                # # Save the image to the specified path
                # with open(save_path_with_extension, 'wb') as file:
                #     for chunk in response.iter_content(1024):
                #         file.write(chunk)
                
                return save_path_with_extension
            elif response.status_code == 429:
                print(f"Rate limited. Retrying in {delay} seconds... (Attempt {attempt + 1}/{retries})")
                time.sleep(delay)  # Wait before retrying
            else:
                raise Exception(f"Failed to download image. Status code: {response.status_code}")
        except Exception as e:
            print(f"Attempt {attempt + 1} failed: {e}")
            if attempt == retries - 1:
                raise  # Re-raise the exception if all retries fail
            time.sleep(delay)


if __name__ == "__main__":
    ds = load_dataset(
        "Binaryy/reddit-travel-qa",
        split="train"
    )

    pipe = lmdeploy.pipeline(model_dir)

    Path(DATASET_IMAGES_ROOT_DIR).mkdir(parents=True, exist_ok=True)
    Path(DATASET_TARGET_PATH).parent.mkdir(parents=True, exist_ok=True)

    messages = []
    for i_row, row in tqdm(enumerate(ds)):
        image_url = row["Post URL"]

        if image_url.startswith("https://imgur.com"):
            image_url = image_url.replace("https://imgur.com", "https://i.imgur.com")
            image_url += ".jpeg"

        if is_image_url(image_url):
            prompt_formatted = prompt_format.format(row["Post Title"])
            answer = pipe([prompt_formatted], temperature=0.0, do_sample=False)[0].text

            print()
            print()
            print(row["Post Title"])
            print("Answer:", answer)
            print()
            print()

            image_path = Path(DATASET_IMAGES_ROOT_DIR) / str(i_row)
            image_path_with_extension = download_image(image_url, image_path)

            if image_path_with_extension is None:
                continue

            for question_variation in question_variations:
                messages.append(generate_message(
                    question_variation,
                    answer,
                    image_path_with_extension
                ))
        
        # if i_row == 5: break

    write_messages_to_json(
        DATASET_TARGET_PATH,
        messages
    )
