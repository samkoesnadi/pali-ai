import argparse
from huggingface_hub import snapshot_download

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Download one or more models from Hugging Face Hub.")
    
    # Add argument for the repository IDs
    parser.add_argument(
        "--repo_id", 
        type=str, 
        required=True, 
        nargs='+',  # Allows one or more repository IDs
        help="The repository ID(s) of the model(s) to download (e.g., 'Qwen/Qwen2.5-1.5B-Instruct')."
    )
    
    # Add argument for the output directory (optional)
    parser.add_argument(
        "--output_dir", 
        type=str, 
        default=None, 
        help="The directory where the model(s) will be saved. If not provided, it will be saved in the default cache directory."
    )
    
    # Parse arguments
    args = parser.parse_args()

    # Download each model
    for repo_id in args.repo_id:
        print(f"Downloading model: {repo_id}")
        snapshot_download(repo_id=repo_id, cache_dir=args.output_dir)
        print(f"Download complete for {repo_id}!")

if __name__ == "__main__":
    main()