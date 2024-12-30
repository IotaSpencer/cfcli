lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cfcli/version'
Gem::Specification.new do |spec|
  spec.name = 'cfcli'
  spec.version = CFCLI.version
  spec.authors = ['Ken Spencer']
  spec.email = 'me@iotaspencer.me'
  spec.summary = %q{Script facilitating easy updating of cloudflare zones and cloudflare options}
  spec.description = %q{Gem facilitating easy updating of cloudflare hosted zones/domains/options.}
  spec.homepage = 'https://iotaspencer.me/projects/cfcli'
  spec.license = 'GNU GPL v3'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata = {
        'github_repo'       => 'https://github.com/IotaSpencer/cfcli',
        'bug_tracker_uri'   => 'https://github.com/IotaSpencer/cfcli/issues',
        #'documentation_uri' => 'https://rubydoc.info/gems/cfcli', no API
        'homepage_uri'      => 'https://iotaspencer.me/projects/cfcli',
        'source_code_uri'   => 'https://github.com/IotaSpencer/cfcli',
        'wiki_uri'          => 'https://github.com/IotaSpencer/cfcli/wiki'
    }
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test)/})
  end
  spec.required_ruby_version = '> 3'
  spec.bindir = 'bin'
  spec.executables << 'cfcli'
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'configparser', '~> 0.1'
  spec.add_runtime_dependency 'cloud_party', '~> 0.1'
  spec.add_runtime_dependency 'highline', '~> 3.0'
  spec.add_runtime_dependency 'slugity', '~> 1.1'
  spec.add_runtime_dependency 'gli', '~> 2.22'
  spec.add_runtime_dependency 'terminal-table', '~> 3.0'
  spec.add_runtime_dependency 'os', '~> 1.1'
  spec.add_runtime_dependency 'paint', '~> 2.3'
  spec.add_runtime_dependency 'rake', '~> 13.1'
  spec.add_development_dependency 'bundler', '~> 2.6'
  spec.post_install_message = [
      "Thanks for installing 'cfcli', It means a lot to me."
  ].join("\n")
end