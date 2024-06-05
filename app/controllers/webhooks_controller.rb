require 'sinatra'
require 'line/bot'
require 'dotenv/load'
require 'base64'
require 'openssl'
require 'pg'
require 'faraday'
require 'json'
class WebhooksController < ApplicationController
  # skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_request , only: [:webhook]
  Dotenv.load
  def get_db_connection
    conn = PG.connect(dbname: 'Queueproject_development', user: 'riseplus', password: 'riseplus')
    return conn
  end

  def get_previous_queue_users_count(customer_data)
    conn = get_db_connection
    result = conn.exec_params('SELECT COUNT(*) FROM queue_users WHERE "queue_users"."cusStatus" = $1 AND id < $2', ['1', customer_data["id"]])
    count = result.getvalue(0, 0).to_i
    count
  end

  def get_customer_data(uid)
    conn = get_db_connection
    result = conn.exec_params('SELECT * FROM customers INNER JOIN queue_users ON customers.id = queue_users.customer_id WHERE customers."uidLine" = $1 AND (queue_users."cusStatus" = $2 OR queue_users."cusStatus" = $3)', [uid, '1', '2'])
    customer_data = nil
    result.each do |row|
      customer_data = row
    end
    customer_data
  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = ["2005470517"]
      config.channel_secret = ["c729912c9c100b1ff82622a0a24b04f1"]
      config.channel_token = ["CfuxW6eoxW6azjplMxN7BqW3pWl4iHB+VpSV0SvEKNKktdMpP4OodSXIF+pxHOlu1mEXQM9fnlz+Aw0nD5wyqT847EWGv4a/SMI/0IKYs8jneE+QUXhzMhs/l3jwTu2wPEg9KPqXqWH3TxAeixIywAdB04t89/1O/w1cDnyilFU="]
    }
  end

  def webhook
    http_request_body = request.body.read # Request body string
    # Extract signature from request headercd
    received_signature = request.env['HTTP_X_LINE_SIGNATURE']
    
    # Compute HMAC-SHA256 digest
    digest = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, "c729912c9c100b1ff82622a0a24b04f1", http_request_body)
    if http_request_body.nil? || http_request_body.empty?
      puts "OK"
      status 200
      return
    end
    
    computed_signature = Base64.strict_encode64(digest)
    puts (computed_signature).inspect
    puts (received_signature).inspect
    # Compare received signature and computed signature
    if received_signature == computed_signature
        begin
          events = client.parse_events_from(http_request_body)
          events.each do |event|
            # Your event handling code here
            uid_line = event['source']['userId']
            customer_data = get_customer_data(uid_line)
            case event
            when Line::Bot::Event::Message
              case event.type
              when Line::Bot::Event::MessageType::Text
                if customer_data.nil? && event.message['text'].include?("ติดตามสถานะ")
                  message = {
                      type: 'text',
                      text: "กรุณาจองคิวก่อนค่ะ"
                  }
                  puts customer_data
                client.reply_message(event['replyToken'], message)
                else
                  queue = get_previous_queue_users_count(customer_data)
                  if event.message['text'].include?("ติดตามสถานะ")
                      message = {
                        type: 'text',
                        text: "หมายเลขคิวของคุณ #{customer_data["cusName"]} \nคือ #{customer_data["qNumber"]} จำนวนลูกค้า #{customer_data["cusSeat"]} \nจำนวนคิวก่อนหน้าคุณ #{queue} คิว"
                      }
                      client.reply_message(event['replyToken'], message)
                  end
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
end
