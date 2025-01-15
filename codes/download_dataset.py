import argparse
from datasets import load_dataset

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Download datasets from Hugging Face.")
    parser.add_argument(
        "--repo_id",
        nargs="+",
        required=True,
        help="List of dataset repository IDs to download (e.g., 'imdb', 'username/dataset_name')."
    )
    parser.add_argument(
        "--output_dir",
        default=None,
        help="Directory to cache the downloaded datasets (optional)."
    )
    args = parser.parse_args()

    # Download each dataset
    for repo_id in args.repo_id:
        print(f"Downloading dataset: {repo_id}")
        try:
            dataset = load_dataset(repo_id, cache_dir=args.output_dir)
            print(f"Dataset '{repo_id}' loaded successfully!")
            print(dataset)
        except Exception as e:
            print(f"Failed to load dataset '{repo_id}': {e}")

if __name__ == "__main__":
    main()
