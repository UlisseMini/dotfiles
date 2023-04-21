#!/usr/bin/env python3

import openai
import sys
from subprocess import run
import readline

model = "gpt-3.5-turbo"
messages = [
    # donno if prompting helps. OAI's default is probably good
    # {
    #     "role": "system",
    #     "content": "You are GPT4. An advanced AI assistant trained by OpenAI.",
    # },
]


def chat(role, content, show=True):
    messages.append({"role": role, "content": content})
    if show:
        print(f"{role.title()}: {content}")
    if role == "user":
        response = openai.ChatCompletion.create(
            model=model, messages=messages, stream=True
        )
        content = ""
        print("Assistant:\n", end="", flush=True)
        for r in response:
            delta = r["choices"][0]["delta"]  # type: ignore
            if "content" in delta:
                content += delta["content"]
                print(delta["content"], end="", flush=True)

            if r["choices"][0]["finish_reason"]:  # type: ignore
                print()

        messages.append({"role": "assistant", "content": content})


# def get_clipboard() -> str:
#     cmd = "xclip -selection clipboard -o".split()
#     return run(cmd, capture_output=True).stdout.decode("utf-8")


if __name__ == "__main__":
    # init msg with clipboard if arg is "clip"
    # chat("user", get_clipboard())

    if "shift" in sys.argv[1:]:
        model = "gpt-4"

    while True:
        chat("user", input("User: "), show=False)
