import os
from typing import Literal

os.environ['CUDA_VISIBLE_DEVICES'] = '0'


def infer_multilora(infer_request: 'InferRequest', infer_backend: Literal['vllm', 'pt']):
    # Dynamic LoRA
    adapter_path = safe_snapshot_download('swift/test_lora')
    adapter_path2 = safe_snapshot_download('swift/test_lora2')
    args = BaseArguments.from_pretrained(adapter_path)
    if infer_backend == 'pt':
        engine = PtEngine(args.model)
    elif infer_backend == 'vllm':
        from swift.llm import VllmEngine
        engine = VllmEngine(args.model, enable_lora=True, max_loras=1, max_lora_rank=16)
    template = get_template(args.template, engine.processor, args.system)
    request_config = RequestConfig(max_tokens=512, temperature=0)
    adapter_request = AdapterRequest('lora1', adapter_path)
    adapter_request2 = AdapterRequest('lora2', adapter_path2)

    # use lora
    resp_list = engine.infer([infer_request], request_config, template=template, adapter_request=adapter_request)
    response = resp_list[0].choices[0].message.content
    print(f'lora1-response: {response}')
    # origin model
    resp_list = engine.infer([infer_request], request_config)
    response = resp_list[0].choices[0].message.content
    print(f'response: {response}')
    # use lora
    resp_list = engine.infer([infer_request], request_config, template=template, adapter_request=adapter_request2)
    response = resp_list[0].choices[0].message.content
    print(f'lora2-response: {response}')


def make_lora(adapter):
    adapter_path = safe_snapshot_download(adapter)
    args = BaseArguments.from_pretrained(adapter_path)
    # method1
    # engine = PtEngine(args.model, adapters=[adapter_path])
    # template = get_template(args.template, engine.tokenizer, args.system)
    # engine.default_template = template

    # method2
    # model, processor = args.get_model_processor()
    # model = Swift.from_pretrained(model, adapter_path)
    # template = args.get_template(processor)
    # engine = PtEngine.from_model_template(model, template)

    # method3
    model, tokenizer = get_model_tokenizer(args.model, model_type="qwen2_vl")
    model = Swift.from_pretrained(model, adapter_path)
    print("template", args.template)
    template = get_template(args.template, tokenizer, args.system)
    return PtEngine.from_model_template(model, template)

def infer_lora(engine, infer_request: 'InferRequest'):
    request_config = RequestConfig(max_tokens=512, temperature=0)
    resp_list = engine.infer([infer_request], request_config)
    response = resp_list[0].choices[0].message.content
    print(f'lora-response: \n {infer_request.messages[0]["content"]}: {response}')


if __name__ == '__main__':
    from swift.llm import (PtEngine, RequestConfig, AdapterRequest, get_template, BaseArguments, InferRequest,
                           safe_snapshot_download, get_model_tokenizer)
    from swift.tuners import Swift
    import argparse

    # Create the parser
    parser = argparse.ArgumentParser(description="A simple example of argparse for string input")

    # Add an argument
    parser.add_argument('--adapter', type=str, help='Input string', required=True)

    # Parse the arguments
    args = parser.parse_args()

    engine = make_lora(args.adapter)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'what can you do?'}])
    infer_lora(engine, infer_request)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'Tell me who you are'}])
    infer_lora(engine, infer_request)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'what is Cerasus serrulata?'}])
    infer_lora(engine, infer_request)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'Suggest a range of activities across Asia, from trekking in Nepal to exploring ancient temples in Cambodia and enjoying beaches in Thailand.'}])
    infer_lora(engine, infer_request)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'abstract of'}])
    infer_lora(engine, infer_request)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'Headlines of'}])
    infer_lora(engine, infer_request)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'What makes you unique?'}])
    infer_lora(engine, infer_request)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'Do you use realtime data?'}])
    infer_lora(engine, infer_request)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'The city of Kulob is in'}])
    infer_lora(engine, infer_request)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'Plan a trip to Indonesia'}])
    infer_lora(engine, infer_request)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'What is the biggest deer?'}])
    infer_lora(engine, infer_request)
    infer_request = InferRequest(messages=[{'role': 'user', 'content': 'Rusa apa yang terbesar di dunia?'}])
    infer_lora(engine, infer_request)
    # infer_multilora(infer_request, 'pt')
