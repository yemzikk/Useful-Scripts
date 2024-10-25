
# KSEB Outage Notification Bot

This Python script checks for scheduled power outages from the KSEB website for specified consumer numbers and sends notifications via Telegram. The script runs every 6 hours, alerting users if there are any updates on power outages.

## Features

- Checks the KSEB outage status using consumer numbers.
- Sends outage notifications to a specified Telegram chat.
- Stores the last sent message in a JSON file to avoid duplicate notifications.
- Configurable to work with multiple consumer numbers and corresponding Telegram settings.

## Requirements

- Python 3.x
- Requests library

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yemzikk/Useful-Scripts.git
   cd Useful-Scripts/KSEB-Outage-To-Telegram
   ```

2. **Install the required packages**:
   ```bash
   pip install requests
   ```

3. **Create a configuration file**:
   Create a `config.json` file in the root directory with the following structure:

   ```json
   {
       "configurations": [
           {
               "BOT_TOKEN": "YOUR_BOT_TOKEN",
               "CHAT_ID": "YOUR_CHAT_ID",
               "CONSUMER_NO": "YOUR_CONSUMER_NUMBER"
           },
           {
               "BOT_TOKEN": "ANOTHER_BOT_TOKEN",
               "CHAT_ID": "ANOTHER_CHAT_ID",
               "CONSUMER_NO": "ANOTHER_CONSUMER_NUMBER"
           }
       ]
   }
   ```

   Replace `YOUR_BOT_TOKEN`, `YOUR_CHAT_ID`, and `YOUR_CONSUMER_NUMBER` with your actual Telegram bot token, chat ID, and KSEB consumer number.

4. **Create a JSON file to store last sent messages**:
   Create a file named `last_sent_messages.json` in the same directory. It can be initialized as an empty object:

   ```json
   {}
   ```

## Usage

1. **Run the script manually**:
   ```bash
   python check.py
   ```

2. **Schedule the script to run every 6 hours**:
   - **For Linux**: Use `cron`.
     ```bash
     crontab -e
     ```
     Add the following line:
     ```bash
     0 */6 * * * /usr/bin/python3 /path/to/your/script.py
     ```
   - **For Windows**: Use Task Scheduler to create a task that runs the script every 6 hours.

## Error Handling

The script includes basic error handling for network requests. If there are issues with sending messages to Telegram or fetching outage information, appropriate messages will be printed to the console.

### Common Issues
- **Network Issues**: Ensure you have an active internet connection.
- **API Rate Limits**: If you send too many requests, you may hit Telegram's rate limits. Adjust your schedule accordingly.
- **Invalid Configuration**: Ensure that your `config.json` is correctly formatted and contains valid tokens and IDs.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- KSEB for providing outage data.
- Telegram for their bot API.
