from datasets import load_dataset


datasets_names = [
    ('MBZUAI/LaMini-instruction', 'train'),
    ("Dahoas/instruct-human-assistant-prompt", "train"),
    ("lextale/FirstAidInstructionsDataset", "Superdataset"),
]

for dataset_name, split_name in datasets_names:
    load_dataset(dataset_name, split=split_name)
