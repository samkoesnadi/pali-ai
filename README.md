# Flutter Offline AI Chat

## Overview
This repository contains the source code for a **Flutter-based offline AI chat application**. The AI model runs entirely on the mobile device, providing privacy and efficiency without relying on internet connectivity. The chat also supports **image processing** powered by **Qwen2VL 2B**.

Additionally, this repository includes **QLoRA finetuning** scripts for further training and optimization of the **Large Language Model (LLM)** used in the chat system. If you're looking to build your own AI assistant, many reusable components are available.

**Tested Platform:** Android

## Features
- **Offline AI Chat** – Runs without an internet connection.
- **Image Processing** – Supports visual input using Qwen2VL 2B.
- **Runs on Mobile** – Optimized for on-device execution.
- **QLoRA Fine-tuning** – Fine-tune the LLM efficiently with low-rank adaptation.
- **Modular Components** – Easily reusable parts for your own projects.

## Installation
To run this application, ensure you have Flutter installed. Then, follow these steps:

```sh
# Clone the repository
git clone https://github.com/your-repo/flutter-offline-ai-chat.git
cd flutter-offline-ai-chat

# Install dependencies
flutter pub get

# Run the app on an Android device
flutter run
```

## QLoRA Fine-Tuning
This repository also contains scripts for **QLoRA fine-tuning** to adapt the LLM to your specific needs. To start training:

1. Ensure you have the required dependencies installed (PyTorch, Hugging Face Transformers, etc.).
2. Navigate to the fine-tuning directory.
3. Run the provided scripts with your dataset.

```sh
cd qlora-finetune
python finetune.py --model Qwen2VL-2B --dataset your_dataset
```

## Notes
- This project is experimental and provided **as-is** without guarantees.
- Take what you need and modify it to suit your requirements.
- Contributions are welcome, but due to its experimental nature, stability is not guaranteed.

## License
[Specify your license here, e.g., MIT, Apache-2.0, etc.]

## Contact
For questions or discussions, open an issue or reach out via [your contact info].

