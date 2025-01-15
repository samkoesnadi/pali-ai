import json


def generate_message(user_prompt, assistant_response, image_path=None):
    if image_path is not None:
        user_prompt = f"<image>{user_prompt}"

    response = {
        "messages": [
            {
                "role": "user",
                "content": user_prompt
            },
            {
                "role": "assistant",
                "content": assistant_response
            },
        ]
    }

    if image_path is not None:
        response["images"] = [image_path]
    
    return response



def write_messages_to_json(output_file, messages):
    with open(output_file, 'w') as outfile:
        for entry in messages:
            json.dump(entry, outfile)
            outfile.write('\n')
