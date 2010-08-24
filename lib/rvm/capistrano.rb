# Recipes for using RVM on a server with capistrano.

unless Capistrano::Configuration.respond_to?(:instance)
  abort "rvm/capistrano requires Capistrano >= 2."
end

Capistrano::Configuration.instance(true).load do

  # Taken from the capistrano code.
  def _cset(name, *args, &block)
    unless exists?(name)
      set(name, *args, &block)
    end
  end

  set :default_shell do
    shell = File.join(rvm_bin_path, "rvm-shell")
    ruby = rvm_ruby_string.to_s.strip
    shell = "#{shell} '#{ruby}'" unless ruby.empty?
    shell
  end

  # Let users set the type of their rvm install.
  _cset(:rvm_type, :system)

  # Let users override the rvm_bin_path
  _cset(:rvm_bin_path) do
    case rvm_type
    when :system_wide, :root, :system
      "/usr/local/bin"
    when :local, :user, :default
      "$HOME/.rvm/bin"
    end
  end

  # Use the default ruby.
  _cset(:rvm_ruby_string, "default")

  # Use rvmsudo
  _cset(:sudo, "rvmsudo")
  _cset(:sudo_prompt, "[sudo] password for #{user}:")
end

# E.g, to use ree and rails 3:
#
#   require 'rvm/capistrano'
#   set :rvm_ruby_string, "ree@rails3"
#
