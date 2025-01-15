
### Convert hf to gguf f32
python convert_hf_to_gguf.py \
    '/root/.cache/huggingface/hub/models--Qwen--Qwen2.5-1.5B-Instruct' \
    --outfile internvl2_5.gguf \
    --outtype f32
