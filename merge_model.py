from transformers import Qwen2VLForConditionalGeneration, AutoTokenizer, AutoProcessor

# List of model names as strings
model_names = [
    "Qwen/Qwen2-VL-2B-Instruct",
    "lmms-lab/Qwen2-VL-2B-GRPO-8k",
    "prithivMLmods/QvQ-Step-Tiny",
]

# Weights ratio for each model (should sum to 1 or be normalized)
weights_ratio = [0.2, 0.4, 0.4]  # Equal weights for simplicity

save_path = "./output/smarter_qwen2vl"

weights_ratio = [weight / sum(weights_ratio) for weight in weights_ratio]
print(weights_ratio)

# Cache directory for storing models
cache_dir = "./models"

# Load models iteratively and store them in a list
models = []
for model_name in model_names:
    model = Qwen2VLForConditionalGeneration.from_pretrained(model_name, torch_dtype="auto", device_map="cpu", cache_dir=cache_dir)
    models.append(model)

# Initialize merged_state_dict with the same keys as the first model
merged_state_dict = {}
for key in models[0].state_dict().keys():
    merged_state_dict[key] = 0  # Initialize with zero

# Merge state_dicts using the weights ratio
for i, model in enumerate(models):
    for key in merged_state_dict.keys():
        merged_state_dict[key] += model.state_dict()[key] * weights_ratio[i]

# Start with one of the models to initialize the merged model
merged_model = Qwen2VLForConditionalGeneration.from_pretrained(model_names[0], cache_dir=cache_dir)

# Load the merged state_dict into the merged model
merged_model.load_state_dict(merged_state_dict)

# Save the merged model to the specified path
merged_model.save_pretrained(save_path)

# Load and save the tokenizer corresponding to the first model
tokenizer = AutoTokenizer.from_pretrained(model_names[0], cache_dir=cache_dir)
tokenizer.save_pretrained(save_path)

# Load and save the processor corresponding to the first model
processor = AutoProcessor.from_pretrained(model_names[0], cache_dir=cache_dir)
processor.save_pretrained(save_path)

print(f"Merged model, tokenizer, and processor saved at: {save_path}")