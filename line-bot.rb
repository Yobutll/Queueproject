# line-bot.rb
require 'sinatra'
require 'line/bot'
require 'dotenv/load'
require 'base64'
require 'openssl'
require 'pg'


Dotenv.load
def get_db_connection
  conn = PG.connect(dbname: 'Queueproject_development', user: 'riseplus', password: 'riseplus')
  return conn
end

# def self.notify_customer_if_status_changed_to_2(customer_data)
#   if customer_data["cusStatus"] == "2"
#     message = {
#       type: 'text',
#       text: "ถึงคิวของคุณแล้วกรุณามาที่หน้าแคชเชียร์"
#     }
#     client.push_message(customer_data["uidLine"], message)
#   end
# end

def get_previous_queue_users_count(customer_data)
  conn = get_db_connection
  result = conn.exec_params('SELECT COUNT(*) FROM queue_users WHERE "queue_users"."cusStatus" = $1 AND id < $2', ['1', customer_data["id"]])
  count = result.getvalue(0, 0).to_i
  count
end

def get_customer_data(uid)
  conn = get_db_connection
  result = conn.exec_params('SELECT * FROM customers INNER JOIN queue_users ON customers.id = queue_users.customer_id WHERE customers."uidLine" = $1', [uid])
  customer_data = nil
  result.each do |row|
    customer_data = row
  end
  customer_data
end

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/webhook' do
  http_request_body = request.body.read # Request body string
  
  # Extract signature from request header
  received_signature = request.env['HTTP_X_LINE_SIGNATURE']
  # Compute HMAC-SHA256 digest
  digest = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, ENV["LINE_CHANNEL_SECRET"], http_request_body)
  
  if http_request_body.nil? || http_request_body.empty?
    puts "OK"
    status 200
    return
  end
  computed_signature = Base64.strict_encode64(digest)
  # Compare received signature and computed signature
  if received_signature == computed_signature
    begin
      events = client.parse_events_from(http_request_body)
      events.each do |event|
        # Your event handling code here
        uid_line = event['source']['userId']
        customer_data = get_customer_data(uid_line)
        queue = get_previous_queue_users_count(customer_data)
        # notify_customer_if_status_changed_to_2(customer_data)
        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Text

            if event.message['text'].include?("ติดตามสถานะ")
              message = {
                type: 'text',
                text: "สถานะ: มีคิวก่อนหน้าคุณ#{queue}คิว\nเวลาที่คาดว่าจะถึง: 15.00 น."
              }
              client.reply_message(event['replyToken'], message)
              puts customer_data.inspect
            else
              message = {
                type: 'text',
                text: "ไม่สามารถตอบกลับข้อความนี้ได้"
              }
              client.reply_message(event['replyToken'], message)
              puts customer_data["id"]
            end
          end
        end
      end
      "OK"
    rescue JSON::ParserError => e
      puts "Error parsing JSON: #{e.message}"
      status 400
      return
    end
  else
    # Signature is not valid, request may be tampered with
    puts "Signature is not valid, request may be tampered with"
    status 402
    return 'Bad Request'
  end
end


