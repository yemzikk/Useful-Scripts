import requests
import json
import re

with open("config.json", "r") as config_file:
    configs = json.load(config_file)["configurations"]

for config in configs:
    BOT_TOKEN = config["BOT_TOKEN"]
    CHAT_ID = config["CHAT_ID"]
    CONSUMER_NO = config["CONSUMER_NO"]

    outage_url = f"https://kseb.in/knowuroutagedetail?consumerno={CONSUMER_NO}"

    response = requests.get(outage_url)
    data = response.json()

    if data.get("isoutage") == 1:
        message = data.get("msg", "").replace("\\/", "/")
        
        message = re.sub(r"</?span[^>]*>", "", message)

        if message:
            telegram_url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
            payload = {
                "chat_id": CHAT_ID,
                "text": message,
                "parse_mode": "HTML"
            }
            telegram_response = requests.post(telegram_url, data=payload)
            
            if telegram_response.status_code == 200:
                print(f"Outage notification sent successfully for Consumer No: {CONSUMER_NO}")
            else:
                print(f"Failed to send message for Consumer No: {CONSUMER_NO}. Error: {telegram_response.text}")
        else:
            print(f"Message content is empty for Consumer No: {CONSUMER_NO}, nothing to send.")
    else:
        print(f"No outage scheduled for Consumer No: {CONSUMER_NO}.")

