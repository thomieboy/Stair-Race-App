# FILENAME initalizer files get started in alphabetical order, this one should be on the end 

require 'mqtt'
require 'yaml'
require 'json'
require 'base64'
require_relative "./../../app/custom_made_libs/MQTTSubscriber.rb"
TTN_CONFIG = YAML.load_file("#{::Rails.root}/config/ttn.yml")

Rails.application.config.ttn = TTN_CONFIG

module StairRaceApp
  class Application < Rails::Application
    config.before_initialize do
      Rails.logger.debug { "spawning new threat" }
      Thread.new do
        Rails.logger.debug { "connecting to ttn" }
        client = MQTT::Client.connect(TTN_CONFIG['server'])
        client = MQTT::SubHandler.new(client) # fix for random disconnections https://github.com/njh/ruby-mqtt/issues/53
        Rails.logger.debug { "connected ttn" }
        client.subscribe_to('vivesiotstairrace/#') do |topicTree, data|
          Rails.logger.debug { "received ttn message" }
          Rails.logger.debug { data }
          begin
            message = JSON.parse(data)
          rescue => ex
            Rails.logger.error ex.message
          end
          Rails.logger.debug { message }
          Leaderboard.new.mqtt(message)
        end
      end
    end
  end
end
