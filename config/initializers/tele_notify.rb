#Set your home URL, so Telegram callbacks work
#For production, just use your URL (e.g. https://myapp.com)
#You MUST NOT include a trailing slash and it MUST be https!
#INVALID URLS: e.g. http://myapp.com or https://myapp.com/
TeleNotify::TelegramUser.configure_home_url("YOUR PRODUCTION URL")

#For development, download ngrok from https://ngrok.com/.
#Extract it and run "./ngrok http 3000"
#Then copy the URL you get from the console window.
#Remember to use the HTTPS URL!
TeleNotify::TelegramUser.configure_dev_url("https://52.78.73.82")

#Set your Telegram Bot API token here
#Don't have your token yet? Create your bot using https://telegram.me/botfather
TeleNotify::TelegramUser.configure_token("288439817:AAFe-ue26ei-WM_2TlMlCfeSkqLE4zvKNKQ")
