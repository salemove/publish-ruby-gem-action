# frozen_string_literal: true

def system!(*cmd)
  puts "Running #{cmd.inspect}"
  system(*cmd, exception: true)
end

workdir = ENV.fetch("WORKDIR", ".")
Dir.chdir(workdir)

Dir.glob("*.gemspec").each do |gemspec_file|
  puts "Building #{gemspec_file}"
  gemspec = Gem::Specification.load(gemspec_file)
  gem_file = gemspec.full_name + ".gem"
  system!("gem", "build", gemspec_file)

  begin
    system!("gem", "push", gem_file)
  rescue => error
    raise unless error.message.include?("Repushing of gem versions is not allowed")
  end
end
