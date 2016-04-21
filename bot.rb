require 'cinch'

def action_string(string)
  "\001ACTION #{string}\001"
end

bot = Cinch::Bot.new do
    configure do |c|
        raise "Environment Variable for Server not Set." unless ENV.has_key?("server")
        raise "Environment Variable for Channel not Set." unless ENV.has_key?("channel")
        c.server   = ENV['server']
        c.channels = [ENV['channel']]

        if ENV.has_key?("username") && ENV.has_key?("password")
          c.nick = ENV['username']
          c.sasl.username = ENV['username']
          c.sasl.password = ENV['password']
        else
          c.nick = "RouletteBot"
        end
    end

    magazine_size = 6
    loaded = false
    bullet = nil
    position = nil

    on :channel, /^!rr$/ do |m|
      m.reply "Russian Roulette: To play, !load the gun, !spin the chamber, then !pull the trigger."
    end

    on :channel, /^!load$/ do |m|
      if !loaded
        m.reply "#{m.user.nick} loads the gun."
        bullet = Random.rand(1...magazine_size + 1)
        loaded = true
      else
        m.reply "The gun is already loaded."
      end
    end

    on :channel, /^!spin$/ do |m|
      if !loaded
        m.reply "You must load the gun first!"
      else
        m.reply "#{m.user.nick} spins the drum."
        position = Random.rand(1...magazine_size + 1)
      end
    end

    on :channel, /^!pull$/ do |m|
      if !loaded
        m.reply "You must load the gun first!"
      elsif position == nil
          m.reply "You must spin the drum first!"
      else
        if bullet == position
          m.reply action_string("shoots #{m.user.nick}.")
          loaded = false
        else
          m.reply action_string("CLICK.")

          if position == magazine_size
            position = 0
          else
            position += 1
          end
        end
      end
    end
end

bot.start
