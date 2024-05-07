require 'line/bot'

# กำหนดค่า Channel Access Token และ Channel Secret
channel_access_token = 'nFSqdyNu6cquPtdUShb3LTzWvNq2g2qkKPIaQOU28FgPRG1veI9XPTgLF/ggJgVpCagldn/6Qql342wD0vxZe58u3PU7jFab7V1EXgehi6EjYHUa0F7krwVc995s1ZtYgZ4QSnXiOHB37cxCXHoaUwdB04t89/1O/w1cDnyilFU=
'
channel_secret = '2b7c7d02492e706b1c0453efbdad18f0'

# สร้าง client instance
client = Line::Bot::Client.new { |config|
  config.channel_secret = channel_secret
  config.channel_token = channel_access_token
}

# ส่งข้อความ
response = client.push_message('USER_ID', {
  type: 'text',
  text: 'Hello, world!'
})

# ตรวจสอบว่าส่งข้อความสำเร็จหรือไม่
puts response.code
puts response.body