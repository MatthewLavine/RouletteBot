require 'cinch'

def action_string(string)
  "\001ACTION #{string}\001"
end

def roulette(m, nick)
  if m.channel.has_user?(nick)
    if Random.rand(1...7).modulo(6).zero?
      m.reply action_string("shoots #{nick}.")
    else
      m.reply action_string("CLICK.")
    end
  else
    m.reply "#{nick} is not online."
  end
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

    on :channel, /^!rr$/ do |m|
      roulette(m, m.user.nick)
    end

    on :channel, /^!rr (.+)$/ do |m, nick|
      roulette(m, nick.strip)
    end
end

bot.start
