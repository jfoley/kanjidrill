# TODO: I'm not so sure this is a good idea.
# But I'm also not sure its NOT a good idea.
# revisit

require 'foreman/engine'

dot_env = Rails.root.join('.env')
Foreman::Engine.read_environment(dot_env).each do |k, v|
  ENV[k] = v
end
