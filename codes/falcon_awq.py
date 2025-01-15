from transformers import AutoTokenizer, AutoModelForCausalLM


model_name = "tiiuae/Falcon3-10B-Instruct-AWQ"

number_of_question = 20

model = AutoModelForCausalLM.from_pretrained(
    model_name,
    torch_dtype="auto",
    device_map="auto"
)
tokenizer = AutoTokenizer.from_pretrained(model_name)

prompt = f"""
Guizhou[a] is an inland province in Southwestern China. Its capital and largest city is Guiyang, in the center of the province. Guizhou borders the autonomous region of Guangxi to the south, Yunnan to the west, Sichuan to the northwest, the municipality of Chongqing to the north, and Hunan to the east. The Guizhou Province has a Humid subtropical climate. It covers a total area of 176,200 square kilometers and consists of six prefecture-level cities and three autonomous prefectures. The population of Guizhou stands at 38.5 million, ranking 18th among the provinces in China.

The Dian Kingdom, which inhabited the present-day area of Guizhou, was annexed by the Han dynasty in 106 BC.[6] Guizhou was formally made a province in 1413 during the Ming dynasty. After the overthrow of the Qing in 1911 and following the Chinese Civil War, the Chinese Communist Party took refuge in Guizhou during the Long March between 1934 and 1935.[7] After the establishment of the People's Republic of China, Mao Zedong promoted the relocation of heavy industry into inland provinces such as Guizhou, to better protect them from potential foreign attacks.[citation needed]

Located in the hinterland of the southwestern inland region, Guizhou is a transportation hub in the southwest area and an important part of the Yangtze River Economic Belt.[8] It is the country's first national-level comprehensive pilot zone for big data,[9] a mountain tourism destination and a major mountain tourism province,[10] a national ecological civilization pilot zone,[11] and an inland open economic pilot zone.[12]

The representative historical culture is "Qian Gui culture"(黔贵文化).[13] In addition, Guizhou is also one of the birthplaces of ancient Chinese humans and ancient Chinese culture, with ancient humans living on this land since about half a million years ago.[14]

Guizhou is rich in natural, cultural and environmental resources. Its natural industry includes timber and forestry, and the energy and mining industries constitute an important part of its economy. Notwithstanding, Guizhou is considered a relatively undeveloped province, with the fourth-lowest GDP per capita in China as of 2020. However, it is also one of China's fastest-growing economies.[15] The Chinese government is looking to develop Guizhou as a data hub.[16][17]

Guizhou is a mountainous province, with its higher altitudes in the west and centre. It lies at the eastern end of the Yungui Plateau. Demographically, it is one of China's most diverse provinces. Minority groups account for more than 37% of the population, including sizable populations of the Miao, Bouyei, Dong, Tujia and Yi peoples, all of whom speak languages distinct from Chinese. The main language spoken in Guizhou is Southwestern Mandarin, a variety of Mandarin.
---
Give me many questions and answers from the previous text about GuiZhou. These questions are what people normally would want to know. Make the questions and answers as long as possible.
Answer in json list of dictionary of "question" and "answer" keys.
"""

prompt = f"""
These administrative divisions are explained in greater detail at administrative divisions of China. The following table lists only the prefecture-level and county-level divisions of Guizhou.
---
Does the previous sentence still need more information? Answer with yes or no
"""

prompt = "Given post title \"My \"land before time\" experience at Angels Landing\", give me a suitable short image description that can be attached in the post. dont generate quotes"

messages = [
    {"role": "system", "content": "You are a helpful friendly assistant Falcon3 from TII, try to follow instructions as much as possible."},
    {"role": "user", "content": prompt}
]
text = tokenizer.apply_chat_template(
    messages,
    tokenize=False,
    add_generation_prompt=True
)
model_inputs = tokenizer([text], return_tensors="pt").to(model.device)

generated_ids = model.generate(
    **model_inputs,
    max_new_tokens=10240,
    do_sample=False,
    top_k=1
)
generated_ids = [
    output_ids[len(input_ids):] for input_ids, output_ids in zip(model_inputs.input_ids, generated_ids)
]

response = tokenizer.batch_decode(generated_ids, skip_special_tokens=True)[0]
print(response.text)
