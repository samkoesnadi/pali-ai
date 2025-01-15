from transformers import pipeline

question = "what is the biggest deer species?"
question = "what is the richest country in africa?"
question = "what is the biggest african country?"

model_paths = [
    "models/models--Space-Cracker--qwen2-VL-2b-instruct-science3/snapshots/ca0ce81d54510302506542b28415b29445212db7",
    "models/models--prithivMLmods--QvQ-Step-Tiny/snapshots/843a21582e6bb15d1e57da5bf35293d3efc50f6c",
    "models/models--apjanco--es_qwen2_vl_pangea/snapshots/c4d49f916ba3ad5d4d429132c6191db705014e27",
    "models/models--arianaa30--qwen2-2b-instruct-trl-sft-ChartQA/snapshots/7b0824602966d238fef947ccfc6f5926b39b1c30",
    "models/models--caijun9--qwen2-7b-instruct-amazon-description/snapshots/57d0b6998ba81128b145bf402bbb087fbddba826",
    "models/models--erax-ai--EraX-VL-2B-V1.5/snapshots/e4d4b5cd046ba526d258a18c08291fbd4e5848a2",
    # "models/models--fmb-quibdo--qwen2-vl-fmb/snapshots/b15c9fb138bdaed2220439f3b822bccbbf903de5",
    "models/models--MonteXiaofeng--IndusryVL-2B-Instruct/snapshots/13038c434d82fa3f26d03c5c01cc3149a06b912f",
    "models/models--prithivMLmods--Omni-Reasoner-2B/snapshots/6989d6d31690d14627e2fdea4921e442460970dd",
    # "models/models--prithivMLmods--Qwen2-VL-OCR-2B-Instruct/snapshots/a54254d5cc9f82e1c362db82adede275d20bbc6b",    
]

for model_path in model_paths:
    generator = pipeline("text-generation", model=model_path, device="cuda")
    output = generator([{"role": "user", "content": question}], max_new_tokens=128, return_full_text=False)[0]
    print(model_path)
    print(output["generated_text"])
    del generator
