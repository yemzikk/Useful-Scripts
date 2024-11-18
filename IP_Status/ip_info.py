import json
import sys
from urllib.request import urlopen

def get_ip_info(ip_address):
    try:
        with urlopen(f"https://ipinfo.io/{ip_address}/json") as response:
            data = response.read()
            return json.loads(data)
    except Exception as e:
        return {"error": f"Unable to fetch IP details: {e}"}

def print_ip_details(ip_details):
    if "error" in ip_details:
        print(f"❌ {ip_details['error']}")
        return

    print(f"📍 IP: {ip_details.get('ip', 'N/A')}")
    print(f"🏙️  City: {ip_details.get('city', 'N/A')}")
    print(f"🌍 Region: {ip_details.get('region', 'N/A')}")
    print(f"🌐 Country: {ip_details.get('country', 'N/A')}")
    print(f"📌 Location: {ip_details.get('loc', 'N/A')}")
    print(f"🏢 Organization: {ip_details.get('org', 'N/A')}")
    print(f"📮 Postal Code: {ip_details.get('postal', 'N/A')}")
    print(f"⏰ Timezone: {ip_details.get('timezone', 'N/A')}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python ip_info.py <IP_ADDRESS>")
        sys.exit(1)

    ip_address = sys.argv[1]
    ip_details = get_ip_info(ip_address)
    print_ip_details(ip_details)
