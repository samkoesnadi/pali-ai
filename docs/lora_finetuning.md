### Text

```
export CUDA_VISIBLE_DEVICES=0
export TOKENIZERS_PARALLELISM=true
swift sft \
    --model /root/.cache/huggingface/hub/models--Qwen--Qwen2-VL-2B-Instruct/snapshots/895c3a49bc3fa70a340399125c650a463535e71c/ \
    --train_type lora \
    --dataset "/root/directory/datasets/processed_training/" \
    --torch_dtype bfloat16 \
    --num_train_epochs 5 \
    --per_device_train_batch_size 2 \
    --per_device_eval_batch_size 1 \
    --gradient_accumulation_steps 16 \
    --learning_rate 1e-4 \
    --lora_rank 5 \
    --lora_alpha 32 \
    --target_modules all-linear \
    --eval_steps 100 \
    --save_steps 100 \
    --save_total_limit 20 \
    --logging_steps 5 \
    --max_length 2048 \
    --output_dir output \
    --warmup_ratio 0.05 \
    --dataloader_num_workers 8 \
    --dataset_num_proc 1 \
    --model_author swift \
    --model_name swift-robot \
    --system 'You are PALI, an offline AI assistant developed by Technology Robot in Indonesia.' \
    --model_type qwen2_vl \
    --template qwen2_vl \
    --split_dataset_ratio 0.00
```

### Image

```
--model /root/.cache/huggingface/hub/models--OpenGVLab--InternVL2_5-4B-MPO/snapshots/e68b42a62863bd8491de02ea1c2ee76b36b88143/ \
export CUDA_VISIBLE_DEVICES=0
export TOKENIZERS_PARALLELISM=true
swift sft \
    --adapters /root/output/v26-20250122-013635/checkpoint-909 \
    --train_type lora \
    --dataset "/root/directory/datasets/images/processed_training/reddit_qa_filtered.jsonl" \
    --torch_dtype bfloat16 \
    --num_train_epochs 5 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 1 \
    --gradient_accumulation_steps 32 \
    --learning_rate 1e-4 \
    --lora_rank 5 \
    --lora_alpha 32 \
    --target_modules all-linear \
    --eval_steps 100 \
    --save_steps 100 \
    --save_total_limit 20 \
    --logging_steps 5 \
    --max_length 2048 \
    --output_dir output \
    --warmup_ratio 0.05 \
    --dataloader_num_workers 8 \
    --dataset_num_proc 1 \
    --model_author swift \
    --model_name swift-robot \
    --system 'You are PALI, an offline AI assistant developed by Technology Robot in Indonesia.' \
    --model_type qwen2_vl \
    --template qwen2_vl \
    --split_dataset_ratio 0.00
```

/root/output/v27-20250122-041733/checkpoint-258
