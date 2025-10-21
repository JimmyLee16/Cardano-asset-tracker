# 💰 Cardano Balance Notification Environment

A simple setup to receive **real-time notifications** whenever your Cardano wallet balance or assets change.  
You can connect it to **Telegram**, **Discord**, **Email**, **Facebook**, or **any other platform** that supports API/webhook integration.

---

## 🧩 1. Overview

This tool monitors your Cardano wallet and notifies you when:
- 💸 Your ADA or token balance changes  
- 📥 You receive or send a transaction  
- 🪙 New native asset appears in your wallet  

Supported notification channels:
- Telegram  
- Discord  
- Email  
- Facebook Messenger  
- Or any API/webhook you want to connect

---

## ⚙️ 2. Setup Environment

You can use any of these sample sources to create your own environment:  
👉 [**Telegram Bot Sample**](https://core.telegram.org/bots/api)  
👉 [**Discord Webhook Guide**](https://discord.com/developers/docs/resources/webhook)  
👉 [**Email (SMTP) Setup**](https://nodemailer.com/about/)  
👉 [**Facebook Graph API**](https://developers.facebook.com/docs/graph-api/)  
👉 [**Custom API / Webhook Example**](https://reqbin.com/)

These links show how to connect your notification channel of choice.  
Then, just integrate it with the tracker script.

---

## 🧠 3. How It Works

1. The script fetches your wallet balance from a Cardano API or node.  
2. It compares with the previous balance.  
3. If there’s any change → sends a message to your connected channel(s).

Example message:
