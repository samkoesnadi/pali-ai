# Qwen2VL benchmarks:

## 2B

### Q4_0

encode_image_with_clip: image encoded in 21975.27 ms by CLIP (   85.84 ms per image patch)

The image depicts a serene waterfront scene in Venice. The focal point is a large, ornate building with multiple domes and intricate architectural details. This building is likely a church or a cathedral due to its grandeur and the domes, which are typical features of Venetian architecture. 

The water in the foreground is calm, reflecting the overcast sky above. To the right of the building, there is a large white bird, likely a seagull, in mid-flight. The bird is in sharp focus, contrasting with the slightly blurred background, emphasizing its motion. The sky is partly cloudy, with patches of blue and white clouds, indicating that the photo was taken during the day.

In the background, there are other buildings, also with similar architectural styles, contributing to the sense of an old, historic city. The overall atmosphere of the image is calm and peaceful, with the combination of natural and man-made elements creating a harmonious balance.
llama_perf_context_print:        load time =   38258.41 ms
llama_perf_context_print: prompt eval time =   12509.05 ms /   281 tokens (   44.52 ms per token,    22.46 tokens per second)
llama_perf_context_print:        eval time =   20927.33 ms /   192 runs   (  109.00 ms per token,     9.17 tokens per second)
llama_perf_context_print:       total time =   59431.07 ms /   473 tokens

### Q4_K_L

encode_image_with_clip: image encoded in 24663.74 ms by CLIP (   96.34 ms per image patch)

The image depicts an elegant, historic building with tall domes and ornate architecture, situated on a river or canal. The building has a classical architectural style, characterized by its grand columns, detailed facade, and intricate stonework. In the foreground, a large bird, likely a seagull, is captured in mid-flight, adding a dynamic element to the scene. The bird is captured in a mid-wing position, soaring over the water body. The background features a bright blue sky with scattered clouds, and the overall setting suggests a serene and picturesque location, possibly a tourist attraction in a city known for its architectural beauty and natural beauty.

llama_perf_context_print:        load time =   44266.75 ms
llama_perf_context_print: prompt eval time =   14861.07 ms /   281 tokens (   52.89 ms per token,    18.91 tokens per second)
llama_perf_context_print:        eval time =   18601.38 ms /   129 runs   (  144.20 ms per token,     6.93 tokens per second)
llama_perf_context_print:       total time =   63089.78 ms /   410 tokens

### Q5_K_L

encode_image_with_clip: image encoded in 22066.69 ms by CLIP (   86.20 ms per image patch)

The image depicts a picturesque scene from Venice, Italy. In the foreground, a seagull is flying gracefully over a canal. The building in the background appears to be a historic structure with a dome and several clock towers, reminiscent of the famous Basilica di Santa Maria della Salute in Venice. The sky is partly cloudy, adding a serene atmosphere to the scene.
llama_perf_context_print:        load time =   43675.83 ms
llama_perf_context_print: prompt eval time =   17299.44 ms /   281 tokens (   61.56 ms per token,    16.24 tokens per second)
llama_perf_context_print:        eval time =   10553.72 ms /    74 runs   (  142.62 ms per token,     7.01 tokens per second)
llama_perf_context_print:       total time =   54426.62 ms /   355 tokens

### IQ4_NL

encode_image_with_clip: image encoded in 30723.38 ms by CLIP (  120.01 ms per image patch)

The image depicts an aerial view of a historic building located on a river or canal. The building has a large dome and several ornate windows, suggesting it could be a church or a significant historical structure. The sky is clear with some clouds, and a white bird, possibly a seagull, is flying over the building, providing a sense of scale and movement to the scene. The building is situated on the riverbanks, and there are other buildings along the shoreline, indicating a densely populated area. The overall atmosphere of the image is serene and picturesque, capturing the beauty of a historical landmark and the tranquility of the environment.
llama_perf_context_print:        load time =   56418.58 ms
llama_perf_context_print: prompt eval time =   22980.58 ms /   281 tokens (   81.78 ms per token,    12.23 tokens per second)
llama_perf_context_print:        eval time =   24542.16 ms /   127 runs   (  193.25 ms per token,     5.17 tokens per second)
llama_perf_context_print:       total time =   81268.31 ms /   408 tokens

### Q8

encode_image_with_clip: image encoded in 22155.05 ms by CLIP (   86.54 ms per image patch)

The image depicts a serene riverside scene in what appears to be a historic city. The foreground features a body of water, possibly a canal, with a bird, likely a seagull, flying gracefully above it. The bird is white with black wingtips, and it is captured in mid-flight. 

The middle ground is dominated by a grand, classical-style building with tall, domed structures on top, reminiscent of Renaissance architecture. The building has large windows and intricate details, suggesting it might be a significant landmark. 

In the background, there are additional buildings with a similar architectural style, suggesting that this is a historical district. The sky is partly cloudy, with patches of blue visible between the clouds, indicating a bright and sunny day. The overall atmosphere is peaceful and picturesque, capturing the charm of a European cityscape.
llama_perf_context_print:        load time =   42002.27 ms
llama_perf_context_print: prompt eval time =   14960.12 ms /   281 tokens (   53.24 ms per token,    18.78 tokens per second)
llama_perf_context_print:        eval time =   32776.56 ms /   167 runs   (  196.27 ms per token,     5.10 tokens per second)
llama_perf_context_print:       total time =   75052.83 ms /   448 tokens

### f16


## 7B

### IQ2_M


