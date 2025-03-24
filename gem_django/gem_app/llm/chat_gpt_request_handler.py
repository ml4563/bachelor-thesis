from openai import OpenAI
from decouple import config

class chat_gpt_request_handler:    
    # Initialize OpenAI client with API key
    client = OpenAI(api_key=config('OPENAI_API_KEY'))

    def make_request(self, parameters, text):
        """
        Sends a request to the ChatGPT API to obtain a chat completion.
        """
        response = self.client.chat.completions.create(
            model=parameters["model"],
            messages=[
                {"role": "system",
                 "content": parameters["content"]
                },
                {
                "role": "user",
                "content":
                parameters['prompt'] + text
                }
            ],
            max_tokens=parameters["maxTokens"],
            temperature=parameters["temperature"],
            top_p=parameters["topP"],
            frequency_penalty=parameters["frequencyPenalty"],
            presence_penalty=parameters["presencePenalty"],
        )
        return response.choices[0].message.content.strip()